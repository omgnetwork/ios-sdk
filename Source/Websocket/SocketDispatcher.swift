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

    func dispatchError(_ error: OMGError) {
        self.commonHandler?.didReceiveError(error)
    }

    func dispatch(_ payload: GenericObjectEnum, event: SocketEvent) {
        switch self {
        case .user(let handler):
            self.handleUserEvents(withHandler: handler, payload: payload, event: event)
        case .transactionRequest(let handler):
            self.handleTransactionRequestEvents(withHandler: handler, payload: payload, event: event)
        case .transactionConsumption(let handler):
            self.handleTransactionConsumptionEvents(withHandler: handler, payload: payload, event: event)
        }
    }

    private func handleUserEvents(withHandler handler: UserEventDelegate?, payload: GenericObjectEnum, event: SocketEvent) {
        switch payload {
        case .transactionConsumption(object: let object):
            handler?.didReceive(.transactionConsumption(object: object), forEvent: event)
        case .error(error: let error):
            self.dispatchError(error)
        default: break
        }
    }

    private func handleTransactionRequestEvents(withHandler handler: TransactionRequestEventDelegate?,
                                                payload: GenericObjectEnum,
                                                event: SocketEvent) {
        switch payload {
        case .transactionConsumption(object: let transactionConsumption) where event == .transactionConsumptionRequest:
            handler?.didReceiveTransactionConsumptionRequest(transactionConsumption, forEvent: event)
        case .error(error: let error):
            self.dispatchError(error)
        default: break
        }
    }

    private func handleTransactionConsumptionEvents(withHandler handler: TransactionConsumptionEventDelegate?,
                                                    payload: GenericObjectEnum,
                                                    event: SocketEvent) {
        switch payload {
        case .transactionConsumption(object: let transactionConsumption):
            switch event {
            case .transactionConsumptionApproved:
                handler?.didReceiveTransactionConsumptionApproval(transactionConsumption, forEvent: event)
            case .transactionConsumptionRejected:
                handler?.didReceiveTransactionConsumptionRejection(transactionConsumption, forEvent: event)
            default: break
            }
        case .error(error: let error):
            self.dispatchError(error)
        default: break
        }
    }

}
