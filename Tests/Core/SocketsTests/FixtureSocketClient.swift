//
//  FixtureSocketClient.swift
//  Tests
//
//  Created by Mederic Petit on 23/3/18.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

import Starscream

class FixtureWebsocketClient: WebSocketClient {
    var delegate: WebSocketDelegate?
    var disableSSLCertValidation: Bool = true
    var overrideTrustHostname: Bool = false
    var desiredTrustHostname: String?
    var security: SSLTrustValidator?
    var enabledSSLCipherSuites: [SSLCipherSuite]?
    var isConnected: Bool = false

    var didWriteString: String?
    var didWriteData: Data?

    var shouldAutoConnect = true

    func connect() {
        self.isConnected = self.shouldAutoConnect
    }

    func disconnect(forceTimeout _: TimeInterval?, closeCode _: UInt16) {
        self.isConnected = false
    }

    func write(string: String, completion: (() -> Void)?) {
        self.didWriteString = string
        completion?()
    }

    func write(data: Data, completion: (() -> Void)?) {
        self.didWriteData = data
        completion?()
        (self.delegate as? TestWebSocketDelegate)?.websocketDidSendData(socket: self, data: data)
    }

    func write(ping _: Data, completion: (() -> Void)?) {
        completion?()
    }

    func write(pong _: Data, completion: (() -> Void)?) {
        completion?()
    }

    func simulateReply() {
        let data = StubGenerator.fileContent(forResource: "socket_response_reply")
        self.delegate?.websocketDidReceiveMessage(socket: self, text: String(data: data, encoding: .utf8)!)
    }
}
