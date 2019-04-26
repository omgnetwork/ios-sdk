//
//  SocketDelegate.swift
//  OmiseGO
//
//  Created by Mederic Petit on 9/3/18.
//  Copyright © 2017-2019 Omise Go Pte. Ltd. All rights reserved.
//

/// A protocol containing the websocket connection events
public protocol SocketConnectionDelegate: AnyObject {
    func didConnect()
    func didDisconnect(_ error: OMGError?)
}

/// The root protocol of all events that are available when listening any topic
public protocol EventDelegate: AnyObject {
    func didStartListening()
    func didStopListening()
    func onError(_ error: APIError)
}

/// The protocol containing events that are dispatched when listening to a user topic
public protocol UserEventDelegate: EventDelegate {
    func on(_ object: WebsocketObject, error: APIError?, forEvent event: SocketEvent)
}

/// The protocol containing events that are dispatched when listening to a transaction request topic
public protocol TransactionRequestEventDelegate: EventDelegate {
    func onTransactionConsumptionRequest(_ transactionConsumption: TransactionConsumption)
    func onSuccessfulTransactionConsumptionFinalized(_ transactionConsumption: TransactionConsumption)
    func onFailedTransactionConsumptionFinalized(_ transactionConsumption: TransactionConsumption, error: APIError)
}

/// The protocol containing events that are dispatched when listening to a transaction consumption topic
public protocol TransactionConsumptionEventDelegate: EventDelegate {
    func onSuccessfulTransactionConsumptionFinalized(_ transactionConsumption: TransactionConsumption)
    func onFailedTransactionConsumptionFinalized(_ transactionConsumption: TransactionConsumption, error: APIError)
}
