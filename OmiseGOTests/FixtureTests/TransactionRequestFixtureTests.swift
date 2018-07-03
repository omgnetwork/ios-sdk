//
//  TransactionRequestFixtureTests.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 5/2/2018.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

import OmiseGO
import XCTest

class TransactionRequestFixtureTests: FixtureTestCase {
    func testGenerateTransactionRequest() {
        let expectation =
            self.expectation(description: "Generate a transaction request corresponding to the params provided")
        let params = StubGenerator.transactionRequestCreateParams(
            type: .receive,
            tokenId: "BTC:861020af-17b6-49ee-a0cb-661a4d2d1f95",
            amount: 1337,
            address: "3b7f1c68-e3bd-4f8f-9916-4af19be95d00",
            correlationId: "31009545-db10-4287-82f4-afb46d9741d8")
        let request =
            TransactionRequest.create(using: self.testClient, params: params) { result in
                defer { expectation.fulfill() }
                switch result {
                case let .success(data: transactionRequest):
                    XCTAssertEqual(transactionRequest.id, "8eb0160e-1c96-481a-88e1-899399cc84dc")
                    XCTAssertEqual(transactionRequest.token.id, "BTC:861020af-17b6-49ee-a0cb-661a4d2d1f95")
                    XCTAssertEqual(transactionRequest.amount, 1337)
                    XCTAssertEqual(transactionRequest.address, "3b7f1c68-e3bd-4f8f-9916-4af19be95d00")
                    XCTAssertEqual(transactionRequest.correlationId, "31009545-db10-4287-82f4-afb46d9741d8")
                    XCTAssertEqual(transactionRequest.status, .valid)
                    XCTAssertEqual(transactionRequest.socketTopic, "transaction_request:8eb0160e-1c96-481a-88e1-899399cc84dc")
                    XCTAssertTrue(transactionRequest.requireConfirmation)
                    XCTAssertEqual(transactionRequest.maxConsumptions, 1)
                    XCTAssertEqual(transactionRequest.consumptionLifetime, 1000)
                    XCTAssertEqual(transactionRequest.expirationDate, "2019-01-01T00:00:00Z".toDate(withFormat: "yyyy-MM-dd'T'HH:mm:ssZ"))
                    XCTAssertEqual(transactionRequest.expirationReason, "Expired")
                    XCTAssertEqual(transactionRequest.createdAt, "2018-01-01T00:00:00Z".toDate(withFormat: "yyyy-MM-dd'T'HH:mm:ssZ"))
                    XCTAssertEqual(transactionRequest.expiredAt, "2019-01-01T00:00:00Z".toDate(withFormat: "yyyy-MM-dd'T'HH:mm:ssZ"))
                    XCTAssertTrue(transactionRequest.allowAmountOverride)
                    XCTAssertTrue(transactionRequest.metadata.isEmpty)
                    XCTAssertTrue(transactionRequest.encryptedMetadata.isEmpty)
                case let .fail(error: error):
                    XCTFail("\(error)")
                }
            }
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }

    func testGetTransactionRequest() {
        let expectation =
            self.expectation(description: "Retrieve a transaction request corresponding to the params provided")
        let request =
            TransactionRequest.get(
                using: self.testClient,
                formattedId: "|8eb0160e-1c96-481a-88e1-899399cc84dc") { result in
                defer { expectation.fulfill() }
                switch result {
                case let .success(data: transactionRequest):
                    XCTAssertEqual(transactionRequest.id, "8eb0160e-1c96-481a-88e1-899399cc84dc")
                    XCTAssertEqual(transactionRequest.token.id, "BTC:861020af-17b6-49ee-a0cb-661a4d2d1f95")
                    XCTAssertEqual(transactionRequest.amount, 1337)
                    XCTAssertEqual(transactionRequest.address, "3b7f1c68-e3bd-4f8f-9916-4af19be95d00")
                    XCTAssertEqual(transactionRequest.correlationId, "31009545-db10-4287-82f4-afb46d9741d8")
                    XCTAssertEqual(transactionRequest.status, .valid)
                    XCTAssertEqual(transactionRequest.socketTopic, "transaction_request:8eb0160e-1c96-481a-88e1-899399cc84dc")
                    XCTAssertTrue(transactionRequest.requireConfirmation)
                    XCTAssertEqual(transactionRequest.maxConsumptions, 1)
                    XCTAssertEqual(transactionRequest.consumptionLifetime, 1000)
                    XCTAssertEqual(transactionRequest.expirationDate, "2019-01-01T00:00:00Z".toDate(withFormat: "yyyy-MM-dd'T'HH:mm:ssZ"))
                    XCTAssertEqual(transactionRequest.expirationReason, "Expired")
                    XCTAssertEqual(transactionRequest.createdAt, "2018-01-01T00:00:00Z".toDate(withFormat: "yyyy-MM-dd'T'HH:mm:ssZ"))
                    XCTAssertEqual(transactionRequest.expiredAt, "2019-01-01T00:00:00Z".toDate(withFormat: "yyyy-MM-dd'T'HH:mm:ssZ"))
                    XCTAssertTrue(transactionRequest.allowAmountOverride)
                    XCTAssertTrue(transactionRequest.metadata.isEmpty)
                    XCTAssertTrue(transactionRequest.encryptedMetadata.isEmpty)
                case let .fail(error: error):
                    XCTFail("\(error)")
                }
            }
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
}
