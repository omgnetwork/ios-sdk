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
    func didReceiveError(_ error: OMGError)
}

public protocol UserEventDelegate: EventDelegate {
    func didReceive(_ object: WebsocketObject, forEvent event: SocketEvent)
}

public protocol TransactionRequestEventDelegate: EventDelegate {
    func didReceiveTransactionConsumptionRequest(_ transactionConsumption: TransactionConsumption, forEvent event: SocketEvent)
}

public protocol TransactionConsumptionEventDelegate: EventDelegate {
    func didReceiveTransactionConsumptionApproval(_ transactionConsumption: TransactionConsumption, forEvent event: SocketEvent)
    func didReceiveTransactionConsumptionRejection(_ transactionConsumption: TransactionConsumption, forEvent event: SocketEvent)
}
