//
//  SocketChannel.swift
//  OmiseGO
//
//  Created by Mederic Petit on 12/3/18.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

protocol SocketSendable: class {
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
        self.socket?.send(topic: topic, event: .join).onSuccess({ _ in
            self.dispatcher?.dispatchJoin()
        })
    }

    func leave(onSuccess: @escaping (() -> Void)) {
        self.socket?.send(topic: self.topic, event: .leave).onSuccess({ _ in
            self.dispatcher?.dispatchLeave()
            onSuccess()
        })
    }

    func dispatchEvents(_ message: SocketMessage) {
        if let error = message.error {
            self.dispatcher?.dispatchError(error)
            return
        }
        guard let payload = message.dataReceived else { return }
        self.dispatcher?.dispatch(payload.data.object, event: payload.event)
    }

}
