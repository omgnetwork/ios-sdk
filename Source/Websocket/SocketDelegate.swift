//
//  SocketDelegate.swift
//  OmiseGO
//
//  Created by Mederic Petit on 9/3/18.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

public protocol SocketConnectionDelegate: class {
    func didConnect()
    func didDisconnect(_ error: OMGError?)
}

public protocol EventDelegate: class {
    func didStartListening()
    func didStopListening()
    func onError(_ error: APIError)
}

public protocol UserEventDelegate: EventDelegate {
    func on(_ object: WebsocketObject, error: APIError?, forEvent event: SocketEvent)
}

public protocol TransactionRequestEventDelegate: EventDelegate {
    func onTransactionConsumptionRequest(_ transactionConsumption: TransactionConsumption)
    func onSuccessfulTransactionConsumptionFinalized(_ transactionConsumption: TransactionConsumption)
    func onFailedTransactionConsumptionFinalized(_ transactionConsumption: TransactionConsumption, error: APIError)
}

public protocol TransactionConsumptionEventDelegate: EventDelegate {
    func onSuccessfulTransactionConsumptionFinalized(_ transactionConsumption: TransactionConsumption)
    func onFailedTransactionConsumptionFinalized(_ transactionConsumption: TransactionConsumption, error: APIError)
}
