//
//  SocketMessage.swift
//  OmiseGO
//
//  Created by Mederic Petit on 12/3/18.
//  Copyright © 2017-2019 Omise Go Pte. Ltd. All rights reserved.
//

class SocketMessage {
    let dataSent: SocketPayloadSend?
    var dataReceived: SocketPayloadReceive?
    private var errorHandler: ((APIError) -> Void)?
    private var successHandler: ((GenericObjectEnum?) -> Void)?

    init(socketPayload: SocketPayloadSend) {
        self.dataSent = socketPayload
    }

    init(socketPayload: SocketPayloadReceive) {
        self.dataSent = nil
        self.dataReceived = socketPayload
    }

    @discardableResult
    func onSuccess(_ handler: @escaping ((GenericObjectEnum?) -> Void)) -> SocketMessage {
        self.successHandler = handler
        return self
    }

    @discardableResult
    func onError(_ handler: @escaping ((APIError) -> Void)) -> SocketMessage {
        self.errorHandler = handler
        return self
    }

    func topic() -> String {
        return self.dataSent?.topic ?? self.dataReceived?.topic ?? "undefined"
    }

    func handleResponse(withPayload payload: SocketPayloadReceive) {
        self.dataReceived = payload
        self.fireCallbacksAndCleanup()
    }

    private func fireCallbacksAndCleanup() {
        defer {
            self.errorHandler = nil
            self.successHandler = nil
        }
        if let error = self.dataReceived?.error {
            self.errorHandler?(error)
        } else {
            self.successHandler?(self.dataReceived?.data?.object)
        }
    }
}
