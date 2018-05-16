//
//  TransactionRequestLiveTest.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 16/5/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import XCTest
import OmiseGO
import DVR

class TransactionRequestLiveTest: LiveTestCase {

    private func validCreationParams() -> TransactionRequestCreateParams {
        return TransactionRequestCreateParams(
            type: .receive,
            mintedTokenId: self.validMintedTokenId,
            amount: 1,
            address: nil,
            correlationId: nil,
            requireConfirmation: true,
            maxConsumptions: nil,
            consumptionLifetime: nil,
            expirationDate: nil,
            allowAmountOverride: true,
            maxConsumptionsPerUser: nil,
            metadata: [:],
            encryptedMetadata: [:])!
    }

    func testGenerateTransactionRequest() {
        let client = self.validHTTPClient(withCassetteName: "me.create_transaction_request")
        let expectation =
            self.expectation(description: "Generate a transaction request corresponding to the params provided")
        let request =
            TransactionRequest.generateTransactionRequest(using: client, params: self.validCreationParams()) { (result) in
                defer { expectation.fulfill() }
                switch result {
                case .success(data: let transactionRequest):
                    XCTAssertEqual(transactionRequest.mintedToken.id, self.validMintedTokenId)
                    XCTAssertEqual(transactionRequest.amount, 1)
                    XCTAssertEqual(transactionRequest.status, .valid)
                    XCTAssertTrue(transactionRequest.requireConfirmation)
                    XCTAssertTrue(transactionRequest.allowAmountOverride)
                    XCTAssertTrue(transactionRequest.metadata.isEmpty)
                    XCTAssertTrue(transactionRequest.encryptedMetadata.isEmpty)
                case .fail(error: let error):
                    XCTFail("\(error)")
                }
        }
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }

    func testGetTransactionRequest() {
        let session = Session(cassetteName: "me.get_transaction_request")
        session.beginRecording()
        let client = HTTPClient(config: self.validHTTPConfig, session: session)

        var transactionRequestId: String?
        let createExpectation =
            self.expectation(description: "Generate a transaction request corresponding to the params provided")
        TransactionRequest.generateTransactionRequest(using: client, params: self.validCreationParams()) { (result) in
            defer { createExpectation.fulfill() }
            switch result {
            case .success(data: let transactionRequest):
                transactionRequestId = transactionRequest.id
            case .fail(error: let error):
                XCTFail("\(error)")
            }
        }
        wait(for: [createExpectation], timeout: 15.0)

        let getExpectation = self.expectation(description: "Get the previously generated transaction request")
        let request = TransactionRequest.retrieveTransactionRequest(using: client, id: transactionRequestId!) { (result) in
            defer { getExpectation.fulfill() }
            session.endRecording()
            switch result {
            case .success(data: let transactionRequest):
                XCTAssertEqual(transactionRequest.id, transactionRequestId!)
            case .fail(error: let error):
                XCTFail("\(error)")
            }
        }
        XCTAssertNotNil(request)
        wait(for: [getExpectation], timeout: 15.0)
    }
}
