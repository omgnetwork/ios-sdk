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

    let eventExpectation: XCTestExpectation?
    let joinExpectation: XCTestExpectation?

    init(eventExpectation: XCTestExpectation? = nil, joinExpectation: XCTestExpectation? = nil) {
        self.eventExpectation = eventExpectation
        self.joinExpectation = joinExpectation
    }

    var didJoin: Bool = false
    var didLeave: Bool = false
    var didReceiveObject: WebsocketObject?
    var didReceiveTransactionConsumptionRequest: TransactionConsumption?
    var didReceiveTransactionConsumptionApproved: TransactionConsumption?
    var didReceiveTransactionConsumptionRejected: TransactionConsumption?
    var didReceiveEvent: SocketEvent?
    var didReceiveError: OmiseGOError?

}

extension DummySocketEventDelegate: UserEventDelegate {

    func didReceive(_ object: WebsocketObject, forEvent event: SocketEvent) {
        self.didReceiveObject = object
        self.didReceiveEvent = event
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

    func didReceiveError(_ error: OmiseGOError) {
        self.didReceiveError = error
        self.joinExpectation?.fulfill()
    }

}

extension DummySocketEventDelegate: TransactionRequestEventDelegate {

    func didReceiveTransactionConsumptionRequest(_ transactionConsumption: TransactionConsumption, forEvent event: SocketEvent) {
        self.didReceiveTransactionConsumptionRequest = transactionConsumption
        self.didReceiveEvent = event
        self.eventExpectation?.fulfill()
    }

}

extension DummySocketEventDelegate: TransactionConsumptionEventDelegate {

    func didReceiveTransactionConsumptionApproval(_ transactionConsumption: TransactionConsumption, forEvent event: SocketEvent) {
        self.didReceiveTransactionConsumptionApproved = transactionConsumption
        self.didReceiveEvent = event
        self.eventExpectation?.fulfill()
    }

    func didReceiveTransactionConsumptionRejection(_ transactionConsumption: TransactionConsumption, forEvent event: SocketEvent) {
        self.didReceiveTransactionConsumptionRejected = transactionConsumption
        self.didReceiveEvent = event
        self.eventExpectation?.fulfill()
    }

}
