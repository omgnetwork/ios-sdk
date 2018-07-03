//
//  DummySocketEventDelegate.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 22/3/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

@testable import OmiseGO
import XCTest

class DummySocketEventDelegate {
    var eventExpectation: XCTestExpectation?
    let joinExpectation: XCTestExpectation?

    init(eventExpectation: XCTestExpectation? = nil, joinExpectation: XCTestExpectation? = nil) {
        self.eventExpectation = eventExpectation
        self.joinExpectation = joinExpectation
    }

    var didJoin: Bool = false
    var didLeave: Bool = false
    var didReceiveObject: WebsocketObject?
    var didReceiveTransactionConsumptionRequest: TransactionConsumption?
    var didReceiveTransactionConsumptionFinalized: TransactionConsumption?
    var didReceiveTransactionConsumptionError: APIError?
    var didReceiveEvent: SocketEvent?
    var didReceiveError: APIError?
}

extension DummySocketEventDelegate: UserEventDelegate {
    func on(_ object: WebsocketObject, error: APIError?, forEvent event: SocketEvent) {
        self.didReceiveObject = object
        self.didReceiveEvent = event
        self.didReceiveError = error
        self.eventExpectation?.fulfill()
    }

    func didStartListening() {
        self.didJoin = true
        self.joinExpectation?.fulfill()
    }

    func didStopListening() {
        self.didLeave = true
        self.joinExpectation?.fulfill()
    }

    func onError(_ error: APIError) {
        self.didReceiveError = error
        self.joinExpectation?.fulfill()
    }
}

extension DummySocketEventDelegate: TransactionRequestEventDelegate {
    func onTransactionConsumptionRequest(_ transactionConsumption: TransactionConsumption) {
        self.didReceiveTransactionConsumptionRequest = transactionConsumption
        self.eventExpectation?.fulfill()
    }
}

extension DummySocketEventDelegate: TransactionConsumptionEventDelegate {
    func onSuccessfulTransactionConsumptionFinalized(_ transactionConsumption: TransactionConsumption) {
        self.didReceiveTransactionConsumptionFinalized = transactionConsumption
        self.eventExpectation?.fulfill()
    }

    func onFailedTransactionConsumptionFinalized(_ transactionConsumption: TransactionConsumption,
                                                 error: APIError) {
        self.didReceiveTransactionConsumptionFinalized = transactionConsumption
        self.didReceiveTransactionConsumptionError = error
        self.eventExpectation?.fulfill()
    }
}
