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
        case .user(let handler): return handler
        case .transactionRequest(let handler): return handler
        case .transactionConsumption(let handler): return handler
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
        case .user(let handler):
            self.handleUserEvents(withHandler: handler, payload: payload)
        case .transactionRequest(let handler):
            self.handleTransactionRequestEvents(withHandler: handler, payload: payload)
        case .transactionConsumption(let handler):
            self.handleTransactionConsumptionEvents(withHandler: handler, payload: payload)
        }
    }

    private func handleUserEvents(withHandler handler: UserEventDelegate?, payload: SocketPayloadReceive) {
        switch (payload.data?.object, payload.error) {
        case (.transactionConsumption(object: let object)?, let error):
            handler?.on(.transactionConsumption(object: object), error: error, forEvent: payload.event)
        case (_, .some(let error)):
            self.dispatchError(error)
        default: break
        }
    }

    private func handleTransactionRequestEvents(withHandler handler: TransactionRequestEventDelegate?,
                                                payload: SocketPayloadReceive) {
        switch (payload.data?.object, payload.error, payload.event) {
        case (.some(.transactionConsumption(object: let transactionConsumption)),
              .none,
              .transactionConsumptionRequest):
            handler?.onTransactionConsumptionRequest(transactionConsumption)
        case (.some(.transactionConsumption(object: let transactionConsumption)),
              .some(let error),
              .transactionConsumptionFinalized):
            handler?.onFailedTransactionConsumptionFinalized(transactionConsumption, error: error)
        case (.some(.transactionConsumption(object: let transactionConsumption)),
              .none,
              .transactionConsumptionFinalized):
            handler?.onSuccessfulTransactionConsumptionFinalized(transactionConsumption)
        case (_, .some(let error), _):
            self.dispatchError(error)
        default: break
        }
    }

    private func handleTransactionConsumptionEvents(withHandler handler: TransactionConsumptionEventDelegate?,
                                                    payload: SocketPayloadReceive) {
        switch (payload.data?.object, payload.error, payload.event) {
        case (.some(.transactionConsumption(object: let transactionConsumption)),
              .some(let error),
              .transactionConsumptionFinalized):
            handler?.onFailedTransactionConsumptionFinalized(transactionConsumption, error: error)
        case (.some(.transactionConsumption(object: let transactionConsumption)),
              .none,
              .transactionConsumptionFinalized):
            handler?.onSuccessfulTransactionConsumptionFinalized(transactionConsumption)
        case (_, .some(let error), _):
            self.dispatchError(error)
        default: break
        }
    }

}
