//
//  Listenable.swift
//  OmiseGO
//
//  Created by Mederic Petit on 9/3/18.
//

/// Represents an object that can be listened with websockets
public protocol Listenable {
    var socketTopic: String { get }
}

public extension Listenable {
    /// Stop listening for events
    ///
    /// - Parameter client: The client used when starting to listen
    func stopListening(withClient client: SocketClient) {
        client.leaveChannel(withTopic: self.socketTopic)
    }
}

public extension Listenable where Self == User {
    /// Opens a websocket connection with the server and starts to listen for any event regarding the current user
    ///
    /// - Parameters:
    ///   - client: The correctly initialized client to use for the websocket connection
    ///   - eventDelegate: The delegate that will receive events
    func startListeningEvents(withClient client: SocketClient, eventDelegate: UserEventDelegate?) {
        client.joinChannel(withTopic: self.socketTopic, dispatcher: SocketDispatcher.user(handler: eventDelegate))
    }
}

public extension Listenable where Self == TransactionRequest {
    /// Opens a websocket connection with the server and starts to listen for events happening on this transaction request
    /// Typically, this should be used to listen for consumption request made on the request
    ///
    /// - Parameters:
    ///   - client: The correctly initialized client to use for the websocket connection
    ///   - eventDelegate: The delegate that will receive events
    func startListeningEvents(withClient client: SocketClient, eventDelegate: TransactionRequestEventDelegate?) {
        client.joinChannel(withTopic: self.socketTopic, dispatcher: SocketDispatcher.transactionRequest(handler: eventDelegate))
    }
}

public extension Listenable where Self == TransactionConsumption {
    /// Opens a websocket connection with the server and starts to listen for events happening on this transaction consumption
    /// Typically, this should be used to listen for consumption confirmation
    ///
    /// - Parameters:
    ///   - client: The correctly initialized client to use for the websocket connection
    ///   - eventDelegate: The delegate that will receive events
    func startListeningEvents(withClient client: SocketClient, eventDelegate: TransactionConsumptionEventDelegate?) {
        client.joinChannel(withTopic: self.socketTopic, dispatcher: SocketDispatcher.transactionConsumption(handler: eventDelegate))
    }
}
