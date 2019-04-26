//
//  SocketChannel.swift
//  OmiseGO
//
//  Created by Mederic Petit on 12/3/18.
//  Copyright © 2017-2019 Omise Go Pte. Ltd. All rights reserved.
//

protocol SocketSendable: AnyObject {
    func send(topic: String, event: SocketEventSend) -> SocketMessage
}

struct SocketChannel {
    let topic: String
    private let dispatcher: SocketDispatcher?
    private weak var socket: SocketSendable?

    init(topic: String, socket: SocketSendable, dispatcher: SocketDispatcher?) {
        self.topic = topic
        self.socket = socket
        self.dispatcher = dispatcher
    }

    func join() {
        self.socket?.send(topic: self.topic, event: .join).onSuccess { _ in
            self.dispatcher?.dispatchJoin()
        }
    }

    func leave(onSuccess: @escaping (() -> Void)) {
        self.socket?.send(topic: self.topic, event: .leave).onSuccess { _ in
            self.dispatcher?.dispatchLeave()
            onSuccess()
        }
    }

    func dispatchEvents(forMessage message: SocketMessage) {
        guard let payload = message.dataReceived else { return }
        self.dispatcher?.dispatchPayload(payload)
    }
}
