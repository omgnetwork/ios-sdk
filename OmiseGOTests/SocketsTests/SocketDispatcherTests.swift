//
//  SocketDispatcherTests.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 22/3/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

@testable import OmiseGO
import XCTest

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

    func testDispatchUserEventCallsDelegate() {
        let userDispatcher = SocketDispatcher.user(handler: self.delegate)
        let consumption = StubGenerator.transactionConsumption()
        let payload = GenericObjectEnum.transactionConsumption(object: consumption)
        userDispatcher.dispatchPayload(self.successPayload(withObject: payload))
        switch self.delegate.didReceiveObject! {
        case let .transactionConsumption(object: transactionConsumptionReceived):
            XCTAssertEqual(transactionConsumptionReceived, consumption)
        }
        XCTAssertEqual(self.delegate.didReceiveEvent!, .transactionConsumptionFinalized)
        XCTAssertNil(self.delegate.didReceiveTransactionConsumptionError)
        XCTAssertNil(self.delegate.didReceiveError)
    }

    func testDispatchUserEventWithTransactionError() {
        let userDispatcher = SocketDispatcher.user(handler: self.delegate)
        let consumption = StubGenerator.transactionConsumption()
        let payload = GenericObjectEnum.transactionConsumption(object: consumption)
        userDispatcher.dispatchPayload(
            self.failPayload(withErrorCode: .transactionInsufficientFunds, object: payload)
        )
        switch self.delegate.didReceiveObject! {
        case let .transactionConsumption(object: transactionConsumptionReceived):
            XCTAssertEqual(transactionConsumptionReceived, consumption)
        }
        XCTAssertEqual(self.delegate.didReceiveEvent!, .transactionConsumptionFinalized)
        XCTAssertEqual(self.delegate.didReceiveError!.code, .transactionInsufficientFunds)
    }

    func testDispatchUserEventWithGenericError() {
        let userDispatcher = SocketDispatcher.user(handler: self.delegate)
        userDispatcher.dispatchPayload(self.failPayload(withErrorCode: .websocketError))
        XCTAssertNil(self.delegate.didReceiveObject)
        XCTAssertEqual(self.delegate.didReceiveError!.code, .websocketError)
    }

    func testDispatchTransactionRequestEventTransactionRequest() {
        let transactionConsumptionDispatcher = SocketDispatcher.transactionRequest(handler: self.delegate)
        let consumption = StubGenerator.transactionConsumption()
        let consumptionPayload = GenericObjectEnum.transactionConsumption(object: consumption)
        transactionConsumptionDispatcher.dispatchPayload(
            self.successPayload(withObject: consumptionPayload, event: .transactionConsumptionRequest)
        )
        XCTAssertEqual(self.delegate.didReceiveTransactionConsumptionRequest, consumption)
        XCTAssertNil(self.delegate.didReceiveTransactionConsumptionError)
        XCTAssertNil(self.delegate.didReceiveError)
    }

    func testDispatchTransactionRequestEventFinalizedConsumptionSuccess() {
        let transactionConsumptionDispatcher = SocketDispatcher.transactionRequest(handler: self.delegate)
        let consumption = StubGenerator.transactionConsumption()
        let consumptionPayload = GenericObjectEnum.transactionConsumption(object: consumption)
        transactionConsumptionDispatcher.dispatchPayload(
            self.successPayload(withObject: consumptionPayload)
        )
        XCTAssertEqual(self.delegate.didReceiveTransactionConsumptionFinalized, consumption)
        XCTAssertNil(self.delegate.didReceiveTransactionConsumptionError)
        XCTAssertNil(self.delegate.didReceiveError)
    }

    func testDispatchTransactionRequestEventFinalizedConsumptionError() {
        let transactionConsumptionDispatcher = SocketDispatcher.transactionRequest(handler: self.delegate)
        let consumption = StubGenerator.transactionConsumption()
        let consumptionPayload = GenericObjectEnum.transactionConsumption(object: consumption)
        transactionConsumptionDispatcher.dispatchPayload(
            self.failPayload(withErrorCode: .transactionInsufficientFunds, object: consumptionPayload)
        )
        XCTAssertEqual(self.delegate.didReceiveTransactionConsumptionFinalized, consumption)
        XCTAssertEqual(self.delegate.didReceiveTransactionConsumptionError!.code, .transactionInsufficientFunds)
        XCTAssertNil(self.delegate.didReceiveError)
    }

    func testDispatchTransactionRequestEventWithError() {
        let transactionConsumptionDispatcher = SocketDispatcher.transactionRequest(handler: self.delegate)
        transactionConsumptionDispatcher.dispatchPayload(
            self.failPayload(withErrorCode: .websocketError)
        )
        XCTAssertNil(self.delegate.didReceiveTransactionConsumptionFinalized)
        XCTAssertNil(self.delegate.didReceiveTransactionConsumptionError)
        XCTAssertEqual(self.delegate.didReceiveError!.code, .websocketError)
    }

    func testDispatchTransactionConsumptionEventFinalizedConsumptionSuccess() {
        let transactionConsumptionDispatcher = SocketDispatcher.transactionConsumption(handler: self.delegate)
        let consumption = StubGenerator.transactionConsumption()
        let consumptionPayload = GenericObjectEnum.transactionConsumption(object: consumption)
        transactionConsumptionDispatcher.dispatchPayload(
            self.successPayload(withObject: consumptionPayload)
        )
        XCTAssertEqual(self.delegate.didReceiveTransactionConsumptionFinalized, consumption)
        XCTAssertNil(self.delegate.didReceiveTransactionConsumptionError)
        XCTAssertNil(self.delegate.didReceiveError)
    }

    func testDispatchTransactionConsumptionEventFinalizedConsumptionError() {
        let transactionConsumptionDispatcher = SocketDispatcher.transactionConsumption(handler: self.delegate)
        let consumption = StubGenerator.transactionConsumption()
        let consumptionPayload = GenericObjectEnum.transactionConsumption(object: consumption)
        transactionConsumptionDispatcher.dispatchPayload(
            self.failPayload(withErrorCode: .transactionInsufficientFunds, object: consumptionPayload)
        )
        XCTAssertEqual(self.delegate.didReceiveTransactionConsumptionFinalized, consumption)
        XCTAssertEqual(self.delegate.didReceiveTransactionConsumptionError!.code, .transactionInsufficientFunds)
        XCTAssertNil(self.delegate.didReceiveError)
    }

    func testDispatchTransactionConsumptionEventWithError() {
        let transactionConsumptionDispatcher = SocketDispatcher.transactionConsumption(handler: self.delegate)
        transactionConsumptionDispatcher.dispatchPayload(
            self.failPayload(withErrorCode: .websocketError)
        )
        XCTAssertNil(self.delegate.didReceiveTransactionConsumptionFinalized)
        XCTAssertNil(self.delegate.didReceiveTransactionConsumptionError)
        XCTAssertEqual(self.delegate.didReceiveError!.code, .websocketError)
    }

    private func successPayload(withObject object: GenericObjectEnum,
                                event: SocketEvent = .transactionConsumptionFinalized) -> SocketPayloadReceive {
        return StubGenerator.socketPayloadReceive(event: event,
                                                  data: GenericObject(object: object),
                                                  success: true)
    }

    private func failPayload(withErrorCode code: APIErrorCode,
                             object: GenericObjectEnum? = nil,
                             event: SocketEvent = .transactionConsumptionFinalized) -> SocketPayloadReceive {
        return SocketPayloadReceive(topic: "",
                                    event: event,
                                    ref: "1",
                                    data: (object != nil ? GenericObject(object: object!) : nil),
                                    version: "1", success: false,
                                    error: .init(code: code, description: "dummy_error"))
    }
}
