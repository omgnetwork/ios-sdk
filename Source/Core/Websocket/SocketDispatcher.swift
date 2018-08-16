//
//  SocketDispatcher.swift
//  OmiseGO
//
//  Created by Mederic Petit on 19/3/18.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

enum SocketDispatcher {
    case user(handler: UserEventDelegate?)
    case transactionRequest(handler: TransactionRequestEventDelegate?)
    case transactionConsumption(handler: TransactionConsumptionEventDelegate?)

    var commonHandler: EventDelegate? {
        switch self {
        case let .user(handler): return handler
        case let .transactionRequest(handler): return handler
        case let .transactionConsumption(handler): return handler
        }
    }

    func dispatchJoin() {
        self.commonHandler?.didStartListening()
    }

    func dispatchLeave() {
        self.commonHandler?.didStopListening()
    }

    func dispatchError(_ error: APIError) {
        self.commonHandler?.onError(error)
    }

    func dispatchPayload(_ payload: SocketPayloadReceive) {
        switch self {
        case let .user(handler):
            self.handleUserEvents(withHandler: handler, payload: payload)
        case let .transactionRequest(handler):
            self.handleTransactionRequestEvents(withHandler: handler, payload: payload)
        case let .transactionConsumption(handler):
            self.handleTransactionConsumptionEvents(withHandler: handler, payload: payload)
        }
    }

    private func handleUserEvents(withHandler handler: UserEventDelegate?, payload: SocketPayloadReceive) {
        switch (payload.data?.object, payload.error) {
        case let (.transactionConsumption(object: object)?, error):
            handler?.on(.transactionConsumption(object: object), error: error, forEvent: payload.event)
        case let (_, .some(error)):
            self.dispatchError(error)
        default: break
        }
    }

    private func handleTransactionRequestEvents(withHandler handler: TransactionRequestEventDelegate?,
                                                payload: SocketPayloadReceive) {
        switch (payload.data?.object, payload.error, payload.event) {
        case (let .some(.transactionConsumption(object: transactionConsumption)),
              .none,
              .transactionConsumptionRequest):
            handler?.onTransactionConsumptionRequest(transactionConsumption)
        case (let .some(.transactionConsumption(object: transactionConsumption)),
              let .some(error),
              .transactionConsumptionFinalized):
            handler?.onFailedTransactionConsumptionFinalized(transactionConsumption, error: error)
        case (let .some(.transactionConsumption(object: transactionConsumption)),
              .none,
              .transactionConsumptionFinalized):
            handler?.onSuccessfulTransactionConsumptionFinalized(transactionConsumption)
        case (_, let .some(error), _):
            self.dispatchError(error)
        default: break
        }
    }

    private func handleTransactionConsumptionEvents(withHandler handler: TransactionConsumptionEventDelegate?,
                                                    payload: SocketPayloadReceive) {
        switch (payload.data?.object, payload.error, payload.event) {
        case (let .some(.transactionConsumption(object: transactionConsumption)),
              let .some(error),
              .transactionConsumptionFinalized):
            handler?.onFailedTransactionConsumptionFinalized(transactionConsumption, error: error)
        case (let .some(.transactionConsumption(object: transactionConsumption)),
              .none,
              .transactionConsumptionFinalized):
            handler?.onSuccessfulTransactionConsumptionFinalized(transactionConsumption)
        case (_, let .some(error), _):
            self.dispatchError(error)
        default: break
        }
    }
}
