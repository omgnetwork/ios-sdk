//
//  SocketClient.swift
//  OmiseGO
//
//  Created by Mederic Petit on 12/3/18.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

import Starscream

public class SocketClient {

    private var awaitingResponse: [String: SocketMessage] = [:]
    private var channels: [String: SocketChannel] = [:]
    private var sendBuffer: [SocketMessage] = []
    private var sendBufferTimer: Timer?
    private let flushDelay = 1.0
    private var heartbeatTimer: Timer?
    private let heartbeatDelay = 10.0
    private var reconnectTimer: Timer?
    private let reconnectDelay = 5.0
    private var messageReference: UInt64 = UInt64.min
    private var shouldBeConnected: Bool = false
    private var webSocket: WebSocketClient!
    private var config: ClientConfiguration!

    public weak var delegate: SocketConnectionDelegate?

    /// Initialize a websocket client using a configuration object
    ///
    /// - Parameter
    ///   - config: The configuration object
    ///   - delegate: The delegate that should receive connection events
    /// - Note: the baseURL of the ClientConfiguration needs to be a socket url (wss://your.domain.com)
    public init(config: ClientConfiguration, delegate: SocketConnectionDelegate?) {
        self.config = config
        self.delegate = delegate
        self.initWebSocket()
    }

    // For testing purpose only
    init(websocketClient: WebSocketClient) {
        self.webSocket = websocketClient
        self.webSocket.delegate = self
    }

    /// Invalidate the current (if any) socket connection and prepare the client for a new one with the updated authentication token.
    /// Note that the active connection will be droped and any topic currently subscribed will be unsubscribed.
    /// You will need to start listening for events again.
    ///
    /// - Parameter token: The updated authentication token
    public func updateAuthenticationToken(_ token: String) {
        self.config.authenticationToken = token
        self.cleanup()
        self.initWebSocket()
    }

    func leaveChannel(withTopic topic: String) {
        guard let channel = self.channels[topic] else { return }
        channel.leave(onSuccess: { [weak self] in
            self?.handleLeave(forTopic: topic)
        })
    }

    func joinChannel(withTopic topic: String, dispatcher: SocketDispatcher?) {
        let channel = SocketChannel(topic: topic, socket: self, dispatcher: dispatcher)
        self.joinChannel(channel)
    }

    private func initWebSocket() {
        let request = try? RequestBuilder(requestParameters: RequestParameters(config: self.config)).buildWebsocketRequest()
        assert(request != nil, "Invalid websocket url")
        self.webSocket = WebSocket(request: request!)
        self.webSocket.delegate = self
    }

    private func connect() {
        self.shouldBeConnected = true
        resetBufferTimer()
        self.webSocket.connect()
    }

    private func disconnect() {
        self.shouldBeConnected = false
        self.webSocket.disconnect()
    }

    private func cleanup() {
        self.awaitingResponse.removeAll()
        self.channels.removeAll()
        self.sendBuffer.removeAll()
        self.invalidateTimers()
    }

    @discardableResult
    private func send(message: SocketMessage) -> SocketMessage {
        guard self.webSocket.isConnected else {
            if message.dataSent!.event != .heartbeat {
                // Don't queue heartbeat
                sendBuffer.append(message)
            }
            return message
        }
        guard let payload = message.dataSent else { return message }
        do {
            let json = try payload.encodedPayload()
            self.awaitingResponse[payload.ref] = message
            self.webSocket.write(data: json)
        } catch _ {
            omiseGOWarn("Failed to encode socket payload")
        }
        return message
    }

    private func joinChannel(_ channel: SocketChannel) {
        if !self.webSocket.isConnected { self.connect() }
        if self.channels[channel.topic] != nil { return }
        self.channels[channel.topic] = channel
        channel.join()
    }

    private func handleLeave(forTopic topic: String) {
        self.channels.removeValue(forKey: topic)
        if self.channels.isEmpty { self.disconnect() }
    }

    private func makeRef() -> String {
        let ref = messageReference + 1
        messageReference = (ref == UInt64.max) ? 0 : ref
        return String(ref)
    }

    private func dispatch(message: SocketMessage) {
        guard let channel = channels[message.topic()] else { return }
        channel.dispatchEvents(forMessage: message)
    }

    private func handleReconnect() {
        guard self.shouldBeConnected else {
            self.awaitingResponse.removeAll()
            self.invalidateTimers()
            return
        }
        self.reconnectTimer?.invalidate()
        self.reconnectTimer = Timer.scheduledTimer(withTimeInterval: self.reconnectDelay, repeats: false, block: { [weak self] _ in
            guard let weakself = self, weakself.shouldBeConnected else { return }
            weakself.connect()
        })
    }

    private func invalidateTimers() {
        self.heartbeatTimer?.invalidate()
        self.sendBufferTimer?.invalidate()
        self.reconnectTimer?.invalidate()
    }

    private func startHeartbeatTimer() {
        self.heartbeatTimer?.invalidate()
        self.heartbeatTimer = Timer.scheduledTimer(withTimeInterval: self.heartbeatDelay, repeats: true, block: { _ in
            self.send(topic: "phoenix", event: .heartbeat)
        })
    }

    private func resetBufferTimer() {
        self.sendBufferTimer?.invalidate()
        self.sendBufferTimer = Timer.scheduledTimer(withTimeInterval: self.flushDelay, repeats: true, block: { _ in
            self.flushSendBuffer()
        })
        self.sendBufferTimer?.fire()
    }

    private func flushSendBuffer() {
        guard self.webSocket.isConnected && !self.sendBuffer.isEmpty else { return }
        for data in sendBuffer {
            send(message: data)
        }
        sendBuffer = []
        resetBufferTimer()
    }

}

extension SocketClient: SocketSendable {

    @discardableResult
    func send(topic: String, event: SocketEventSend) -> SocketMessage {
        let payload = SocketPayloadSend(topic: topic, event: event, ref: makeRef())
        let message = SocketMessage(socketPayload: payload)
        return self.send(message: message)
    }

}

extension SocketClient: WebSocketDelegate {

    public func websocketDidConnect(socket: WebSocketClient) {
        self.delegate?.didConnect()
        self.startHeartbeatTimer()
    }

    public func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        if let wsError: WSError  = error as? WSError {
            switch wsError.code {
            case 403: self.delegate?.didDisconnect(.socketError(message: "Authorization error"))
            case Int(CloseCode.normal.rawValue): self.delegate?.didDisconnect(nil)
            default: self.delegate?.didDisconnect(.socketError(message: wsError.message))
            }
        } else if let error = error {
            self.delegate?.didDisconnect(.other(error: error))
        } else {
            self.delegate?.didDisconnect(nil)
        }
        self.handleReconnect()
    }

    public func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        omiseGOInfo("websockets did receive: \(text)")
        guard let data = text.data(using: .utf8), let payload: SocketPayloadReceive = try? deserializeData(data) else { return }
        var message: SocketMessage!
        if let ref = payload.ref, let waitingForResponse = self.awaitingResponse[ref] {
            message = waitingForResponse
            message.handleResponse(withPayload: payload)
            self.awaitingResponse.removeValue(forKey: ref)
        } else {
            message = SocketMessage(socketPayload: payload)
        }
        self.dispatch(message: message)
    }

    public func websocketDidReceiveData(socket: WebSocketClient, data: Data) { /* no-op */ }

}
