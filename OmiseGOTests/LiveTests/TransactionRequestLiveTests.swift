//
//  TransactionRequestLiveTests.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 23/2/18.
//  Copyright © 2018 OmiseGO. All rights reserved.
//

import XCTest
import OmiseGO

class TransactionRequestLiveTests: LiveTestCase {

    func generateTransactionRequest(creationCorrelationId: String) -> TransactionRequest? {
        let generateExpectation = self.expectation(description: "Generate transaction request")
        let transactionRequestParams = TransactionRequestCreateParams(
            type: .receive,
            mintedTokenId: self.validMintedTokenId,
            amount: 1,
            address: nil,
            correlationId: creationCorrelationId)
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
        waitForExpectations(timeout: 15.0, handler: nil)
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
        waitForExpectations(timeout: 15.0, handler: nil)
    }

    func consumeTransactionRequest(transactionRequest: TransactionRequest) {
        let idempotencyToken = UUID().uuidString
        let consumeCorrelationId = UUID().uuidString
        let consumeExpectation = self.expectation(description: "Consume transaction request")
        let transactionConsumeParams = TransactionConsumeParams(
            transactionRequest: transactionRequest,
            address: nil,
            mintedTokenId: nil,
            amount: nil,
            idempotencyToken: idempotencyToken,
            correlationId: consumeCorrelationId,
            metadata: [:])
        let consumeRequest = TransactionConsume.consumeTransactionRequest(
            using: self.testClient,
            params: transactionConsumeParams!) { (result) in
                defer { consumeExpectation.fulfill() }
                switch result {
                case .success(data: let transactionConsume):
                    let mintedToken = transactionConsume.mintedToken
                    XCTAssertEqual(mintedToken.id, self.validMintedTokenId)
                    XCTAssertEqual(transactionConsume.amount, 1)
                    XCTAssertEqual(transactionConsume.correlationId, consumeCorrelationId)
                    XCTAssertEqual(transactionConsume.idempotencyToken, idempotencyToken)
                    XCTAssertEqual(transactionConsume.transactionRequestId, transactionRequest.id)
                    XCTAssertEqual(transactionConsume.status, .confirmed)
                case .fail(error: let error):
                    XCTFail("\(error)")
                }
        }
        XCTAssertNotNil(consumeRequest)
        waitForExpectations(timeout: 15.0, handler: nil)
    }

    func testGenerateThenGetThenConsumeTransactionRequest() {
        let creationCorrelationId = UUID().uuidString
        guard let transactionRequest =
            self.generateTransactionRequest(creationCorrelationId: creationCorrelationId) else { return }
        self.getTransactionRequest(transactionRequestId: transactionRequest.id,
                                   creationCorrelationId: creationCorrelationId)
        self.consumeTransactionRequest(transactionRequest: transactionRequest)
    }

}
