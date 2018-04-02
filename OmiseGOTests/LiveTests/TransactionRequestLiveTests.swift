//
//  TransactionRequestLiveTests.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 23/2/18.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

import XCTest
import OmiseGO

class TransactionRequestLiveTests: LiveTestCase {

    override func setUp() {
        super.setUp()
    }

    /// This test aims to test the full flow of a transfer between users including websocket integration
    /// The problem here is that (for obvious reasons) the eWallet doesn't allow a transfer between 2 same addresses,
    /// this means that we would require to setup the live tests using 2 different authentication tokens for the purpose of this test.
    /// Even if this is doable, we would face an other issue because the user would possibly not have enough balance to make the transfer
    /// so the test would fail.
    /// So it has been decided, for now, that this test will only scope the following:
    // 1) Generate the transaction request
    // 2) Test the get transaction request method
    // 3) Subscribe to events on this transaction request (listen for consumptions request)
    // 4) Try to consume the transaction request
    // 5) Wait for the consumption request via the websockets
    // 6) Confirm the consumption request
    // 7) Assert a same_address error as we did all actions with the same balance

    func testGenerateTransactionRequestThenConsume() {
        let creationCorrelationId = UUID().uuidString
        // FLOW:
        // 1) Generate the transaction request
        guard let transactionRequest = self.generateTransactionRequest(creationCorrelationId: creationCorrelationId) else { return }
        // 2) Test the get method
        self.getTransactionRequest(transactionRequestId: transactionRequest.id, creationCorrelationId: creationCorrelationId)
        // 3) Subscribe to events on this transaction request (listen for consumptions)
        let consumptionDelegate = self.startToListenForConsumption(forTransactionRequest: transactionRequest)
        // 4) Try to consume the transaction request
        //    As it requires confirmation, an event should be send to listeners
        guard self.consumeTransactionRequest(transactionRequest: transactionRequest) != nil else { return }
        // 5) Wait for the consumption to be sent
        let consumptionRequest = self.waitForConsumption(withDelegate: consumptionDelegate)
        // 6) Confirm the consumption
        self.confirmConsumption(withConsumption: consumptionRequest)
    }

    func testGenerateTransactionRequestThenRejectConsumption() {
        let creationCorrelationId = UUID().uuidString
        // FLOW:
        // 1) Generate the transaction request
        guard let transactionRequest = self.generateTransactionRequest(creationCorrelationId: creationCorrelationId) else { return }
        // 2) Test the get method
        self.getTransactionRequest(transactionRequestId: transactionRequest.id, creationCorrelationId: creationCorrelationId)
        // 3) Subscribe to events on this transaction request (listen for consumptions)
        let consumptionDelegate = self.startToListenForConsumption(forTransactionRequest: transactionRequest)
        // 4) Try to consume the transaction request
        //    As it requires confirmation, an event should be send to listeners
        guard let transactionConsumption = self.consumeTransactionRequest(transactionRequest: transactionRequest) else { return }
        // 5) Subscribe to events on this transaction consumption (listen for confirmations)
        let confirmationDelegate = self.startToListenForConfirmation(forConsumption: transactionConsumption)
        // 6) Wait for the consumption to be sent
        let consumptionRequest = self.waitForConsumption(withDelegate: consumptionDelegate)
        // 7) Reject the consumption
        self.rejectConsumption(withConsumption: consumptionRequest)
        // 8) Wait for the rejection to be sent
        let rejectedConsumption = self.waitForRejection(withDelegate: confirmationDelegate)
        XCTAssertEqual(rejectedConsumption.status, .rejected)
        XCTAssertFalse(rejectedConsumption.approved)
        XCTAssertNotNil(rejectedConsumption.finalizedAt)
    }

    func testChannelNotFound() {
        let tc = StubGenerator.transactionConsumption(socketTopic: "transaction_consumption:123")
        let joinExpectation = self.expectation(description: "Fail to join the channel")
        let delegate = DummySocketEventDelegate(joinExpectation: joinExpectation)
        tc.startListeningEvents(withClient: self.testSocketClient, eventDelegate: delegate)
        self.wait(for: [joinExpectation], timeout: 15)
        guard let error = delegate.didReceiveError else {
            XCTFail("Should get an error")
            return
        }
        switch error {
        case .api(apiError: let apiError): XCTAssertEqual(apiError.code, .channelNotFound)
        default: XCTFail("Should get an API error")
        }
    }

}

extension TransactionRequestLiveTests {

    func generateTransactionRequest(creationCorrelationId: String) -> TransactionRequest? {
        let generateExpectation = self.expectation(description: "Generate transaction request")
        let transactionRequestParams = TransactionRequestCreateParams(
            type: .receive,
            mintedTokenId: self.validMintedTokenId,
            amount: 1,
            address: nil,
            correlationId: creationCorrelationId,
            requireConfirmation: true,
            maxConsumptions: 2,
            consumptionLifetime: nil,
            expirationDate: Date().addingTimeInterval(60),
            allowAmountOverride: true,
            metadata: ["a_key": "a_value"])!
        var transactionRequestResult: TransactionRequest?
        let generateRequest = TransactionRequest.generateTransactionRequest(
            using: self.testClient,
            params: transactionRequestParams) { (result) in
                defer { generateExpectation.fulfill() }
                switch result {
                case .success(data: let transactionRequest):
                    transactionRequestResult = transactionRequest
                    XCTAssertEqual(transactionRequest.mintedToken.id, self.validMintedTokenId)
                    XCTAssertEqual(transactionRequest.amount, 1)
                    XCTAssertEqual(transactionRequest.correlationId, creationCorrelationId)
                case .fail(error: let error):
                    XCTFail("\(error)")
                }
        }
        XCTAssertNotNil(generateRequest)
        wait(for: [generateExpectation], timeout: 15.0)
        return transactionRequestResult
    }

    func getTransactionRequest(transactionRequestId: String, creationCorrelationId: String) {
        var transactionRequestResult: TransactionRequest?
        let getExpectation = self.expectation(description: "Get transaction request")
        let getRequest = TransactionRequest.retrieveTransactionRequest(
            using: self.testClient,
            id: transactionRequestId) { (result) in
                defer { getExpectation.fulfill() }
                switch result {
                case .success(data: let transactionRequest):
                    transactionRequestResult = transactionRequest
                    XCTAssertEqual(transactionRequest.id, transactionRequestId)
                    XCTAssertEqual(transactionRequest.mintedToken.id, self.validMintedTokenId)
                    XCTAssertEqual(transactionRequest.amount, 1)
                    XCTAssertEqual(transactionRequest.correlationId, creationCorrelationId)
                case .fail(error: let error):
                    XCTFail("\(error)")
                }
        }
        XCTAssertNotNil(getRequest)
        wait(for: [getExpectation], timeout: 15.0)
    }

    func consumeTransactionRequest(transactionRequest: TransactionRequest) -> TransactionConsumption? {
        let idempotencyToken = UUID().uuidString
        let consumeCorrelationId = UUID().uuidString
        let consumeExpectation = self.expectation(description: "Consume transaction request")
        let transactionConsumptionParams = TransactionConsumptionParams(
            transactionRequest: transactionRequest,
            address: nil,
            mintedTokenId: nil,
            amount: nil,
            idempotencyToken: idempotencyToken,
            correlationId: consumeCorrelationId,
            expirationDate: nil,
            metadata: ["a_key": "a_value"])
        var transactionConsumptionResult: TransactionConsumption?
        let consumeRequest = TransactionConsumption.consumeTransactionRequest(
            using: self.testClient,
            params: transactionConsumptionParams!) { (result) in
                defer { consumeExpectation.fulfill() }
                switch result {
                case .success(data: let transactionConsumption):
                    transactionConsumptionResult = transactionConsumption
                    let mintedToken = transactionConsumption.mintedToken
                    XCTAssertEqual(mintedToken.id, self.validMintedTokenId)
                    XCTAssertEqual(transactionConsumption.amount, 1)
                    XCTAssertEqual(transactionConsumption.correlationId, consumeCorrelationId)
                    XCTAssertEqual(transactionConsumption.idempotencyToken, idempotencyToken)
                    XCTAssertEqual(transactionConsumption.transactionRequestId, transactionRequest.id)
                    XCTAssertEqual(transactionConsumption.status, .pending)
                case .fail(error: let error):
                    XCTFail("\(error)")
                }
        }
        XCTAssertNotNil(consumeRequest)
        wait(for: [consumeExpectation], timeout: 15.0)
        return transactionConsumptionResult
    }

    func startToListenForConsumption(forTransactionRequest transactionRequest: TransactionRequest) -> DummySocketEventDelegate {
        let eventExpectation = self.expectation(description: "Start listening for consumption")
        let joinExpectation = self.expectation(description: "Join channel")
        let delegate = DummySocketEventDelegate(eventExpectation: eventExpectation, joinExpectation: joinExpectation)
        transactionRequest.startListeningEvents(withClient: self.testSocketClient, eventDelegate: delegate)
        wait(for: [joinExpectation], timeout: 15.0)
        XCTAssertTrue(delegate.didJoin)
        return delegate
    }

    func startToListenForConfirmation(forConsumption transactionConsumption: TransactionConsumption) -> DummySocketEventDelegate {
        let eventExpectation = self.expectation(description: "Start listening for confirmation")
        let joinExpectation = self.expectation(description: "Join channel")
        let delegate = DummySocketEventDelegate(eventExpectation: eventExpectation, joinExpectation: joinExpectation)
        transactionConsumption.startListeningEvents(withClient: self.testSocketClient, eventDelegate: delegate)
        wait(for: [joinExpectation], timeout: 15.0)
        XCTAssertTrue(delegate.didJoin)
        return delegate
    }

    func waitForConsumption(withDelegate delegate: DummySocketEventDelegate) -> TransactionConsumption {
        let expectation = delegate.eventExpectation!
        wait(for: [expectation], timeout: 15.0)
        XCTAssertNotNil(delegate.didReceiveTransactionConsumptionRequest)
        XCTAssertEqual(delegate.didReceiveEvent!, SocketEvent.transactionConsumptionRequest)
        return delegate.didReceiveTransactionConsumptionRequest!
    }

    func waitForApproval(withDelegate delegate: DummySocketEventDelegate) -> TransactionConsumption {
        let expectation = delegate.eventExpectation!
        wait(for: [expectation], timeout: 15.0)
        XCTAssertNotNil(delegate.didReceiveTransactionConsumptionApproved)
        XCTAssertNotNil(delegate.didReceiveEvent)
        XCTAssertEqual(delegate.didReceiveEvent!, SocketEvent.transactionConsumptionApproved)
        return delegate.didReceiveTransactionConsumptionApproved!
    }

    func waitForRejection(withDelegate delegate: DummySocketEventDelegate) -> TransactionConsumption {
        let expectation = delegate.eventExpectation!
        wait(for: [expectation], timeout: 15.0)
        XCTAssertNotNil(delegate.didReceiveTransactionConsumptionRejected)
        XCTAssertNotNil(delegate.didReceiveEvent)
        XCTAssertEqual(delegate.didReceiveEvent!, SocketEvent.transactionConsumptionRejected)
        return delegate.didReceiveTransactionConsumptionRejected!
    }

    func confirmConsumption(withConsumption transactionConsumption: TransactionConsumption) {
        let confirmExpectation = self.expectation(description: "Confirm consumption request")
        let confirmationRequest = transactionConsumption.approve(using: self.testClient) { (result) in
            defer { confirmExpectation.fulfill() }
            switch result {
            case .success:
                XCTFail("Shouldn't succeed as we're trying to transfer between the same address")
            case .fail(error: let error):
                switch error {
                case .api(apiError: let apiError): XCTAssertEqual(apiError.code, .sameAddress)
                default: XCTFail("Expected to receive same_address error")
                }
            }
        }
        XCTAssertNotNil(confirmationRequest)
        wait(for: [confirmExpectation], timeout: 15.0)
    }

    func rejectConsumption(withConsumption transactionConsumption: TransactionConsumption) {
        let rejectExpectation = self.expectation(description: "Confirm consumption request")
        let rejectRequest = transactionConsumption.reject(using: self.testClient) { (result) in
            defer { rejectExpectation.fulfill() }
            switch result {
            case .success(data: let transactionConsumption):
                XCTAssertEqual(transactionConsumption.status, .rejected)
                XCTAssertFalse(transactionConsumption.approved)
            case .fail:
                XCTFail("Shouldn't receive error")

            }
        }
        XCTAssertNotNil(rejectRequest)
        wait(for: [rejectExpectation], timeout: 15.0)
    }

}
