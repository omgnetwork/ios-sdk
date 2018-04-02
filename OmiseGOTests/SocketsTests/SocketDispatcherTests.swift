//
//  SocketDispatcherTests.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 22/3/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import XCTest
@testable import OmiseGO

class SocketDispatcherTests: XCTestCase {

    var delegate: DummySocketEventDelegate!

    override func setUp() {
        super.setUp()
        self.delegate = DummySocketEventDelegate()
    }

    func testDispatchJoinCallsJoin() {
        let userDispatcher = SocketDispatcher.user(handler: self.delegate)
        userDispatcher.dispatchJoin()
        XCTAssertTrue(self.delegate.didJoin)
    }

    func testDispatchLeaveCallsLeave() {
        let userDispatcher = SocketDispatcher.user(handler: self.delegate)
        userDispatcher.dispatchLeave()
        XCTAssertTrue(self.delegate.didLeave)
    }

    func testDispatchErrorCallsError() {
        let userDispatcher = SocketDispatcher.user(handler: self.delegate)
        userDispatcher.dispatchError(OMGError.socketError(message: "dummy_error"))
        XCTAssertEqual(self.delegate.didReceiveError!.message, "socket error: dummy_error")
    }

    func testDispatchUserEventCallsDelegate() {
        let userDispatcher = SocketDispatcher.user(handler: self.delegate)
        let consumption = StubGenerator.transactionConsumption()
        let payload = GenericObjectEnum.transactionConsumption(object: consumption)
        userDispatcher.dispatch(payload, event: .transactionConsumptionRequest)
        switch self.delegate.didReceiveObject! {
        case .transactionConsumption(object: let transactionConsumptionReceived):
            XCTAssertEqual(transactionConsumptionReceived, consumption)
        }
        XCTAssertEqual(self.delegate.didReceiveEvent!, .transactionConsumptionRequest)
        userDispatcher.dispatch(.error(error: .socketError(message: "dummy_error")), event: .transactionConsumptionRequest)
        XCTAssertEqual(self.delegate.didReceiveError!.message, "socket error: dummy_error")
    }

    func testDispatchTransactionRequestEventCallsDelegate() {
        let transactionRequestDispatcher = SocketDispatcher.transactionRequest(handler: self.delegate)
        let consumption = StubGenerator.transactionConsumption()
        let payload = GenericObjectEnum.transactionConsumption(object: consumption)
        transactionRequestDispatcher.dispatch(payload, event: .transactionConsumptionRequest)
        XCTAssertEqual(self.delegate.didReceiveTransactionConsumptionRequest, consumption)
        XCTAssertEqual(self.delegate.didReceiveEvent!, .transactionConsumptionRequest)
        transactionRequestDispatcher.dispatch(.error(error: .socketError(message: "dummy_error")), event: .transactionConsumptionRequest)
        XCTAssertEqual(self.delegate.didReceiveError!.message, "socket error: dummy_error")
    }

    func testDispatchTransactionConsumptionEventCallsDelegate() {
        let transactionConsumptionDispatcher = SocketDispatcher.transactionConsumption(handler: self.delegate)
        let consumption = StubGenerator.transactionConsumption()
        let payload = GenericObjectEnum.transactionConsumption(object: consumption)
        transactionConsumptionDispatcher.dispatch(payload, event: .transactionConsumptionApproved)
        XCTAssertEqual(self.delegate.didReceiveTransactionConsumptionApproved, consumption)
        XCTAssertEqual(self.delegate.didReceiveEvent!, .transactionConsumptionApproved)
        transactionConsumptionDispatcher.dispatch(.error(error: .socketError(message: "dummy_error")), event: .transactionConsumptionRequest)
        XCTAssertEqual(self.delegate.didReceiveError!.message, "socket error: dummy_error")
        transactionConsumptionDispatcher.dispatch(payload, event: .transactionConsumptionRejected)
        XCTAssertEqual(self.delegate.didReceiveTransactionConsumptionRejected, consumption)
        XCTAssertEqual(self.delegate.didReceiveEvent!, .transactionConsumptionRejected)
    }

}
