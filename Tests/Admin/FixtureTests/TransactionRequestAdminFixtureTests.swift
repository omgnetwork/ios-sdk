//
//  TransactionRequestAdminFixtureTests.swift
//  Tests
//
//  Created by Mederic Petit on 8/10/18.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

import OmiseGO
import XCTest

class TransactionRequestAdminFixtureTests: FixtureAdminTestCase {
    func testGenerateTransactionRequest() {
        let expectation =
            self.expectation(description: "Generate a transaction request corresponding to the params provided")
        let params = StubGenerator.transactionRequestCreateParams(
            type: .receive,
            tokenId: "tok_TK1_01cs953xjn9hvz1bcet7swq36j",
            amount: 100,
            address: "ykql631634124896",
            correlationId: "wjkehfwjjwbgb",
            requireConfirmation: false,
            maxConsumptions: nil,
            consumptionLifetime: nil)
        let request =
            TransactionRequest.create(using: self.testClient, params: params) { result in
                defer { expectation.fulfill() }
                switch result {
                case let .success(data: transactionRequest):
                    XCTAssertEqual(transactionRequest.id, "txr_01cs9aq1868a2qdyee06w2xvbf")
                    XCTAssertEqual(transactionRequest.token.id, "tok_TK1_01cs953xjn9hvz1bcet7swq36j")
                    XCTAssertEqual(transactionRequest.amount, 100)
                    XCTAssertEqual(transactionRequest.address, "ykql631634124896")
                    XCTAssertEqual(transactionRequest.correlationId, "wjkehfwjjwbgb")
                    XCTAssertEqual(transactionRequest.status, .valid)
                    XCTAssertEqual(transactionRequest.socketTopic, "transaction_request:txr_01cs9aq1868a2qdyee06w2xvbf")
                    XCTAssertFalse(transactionRequest.requireConfirmation)
                    XCTAssertEqual(transactionRequest.maxConsumptions, 1)
                    XCTAssertEqual(transactionRequest.consumptionLifetime, 1000)
                    XCTAssertNil(transactionRequest.expirationDate)
                    XCTAssertNil(transactionRequest.expirationReason)
                    XCTAssertEqual(transactionRequest.createdAt, "2018-10-08T07:54:24Z".toDate(withFormat: "yyyy-MM-dd'T'HH:mm:ssZ"))
                    XCTAssertNil(transactionRequest.expiredAt)
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
            self.expectation(description: "Retreive a transaction request corresponding to the params provided")
        let request =
            TransactionRequest.get(using: self.testClient, formattedId: "txr_01cs9aq1868a2qdyee06w2xvbf") { result in
                defer { expectation.fulfill() }
                switch result {
                case let .success(data: transactionRequest):
                    XCTAssertEqual(transactionRequest.id, "txr_01cs9aq1868a2qdyee06w2xvbf")
                    XCTAssertEqual(transactionRequest.formattedId, "txr_01cs9aq1868a2qdyee06w2xvbf")
                    XCTAssertEqual(transactionRequest.token.id, "tok_TK1_01cs953xjn9hvz1bcet7swq36j")
                    XCTAssertEqual(transactionRequest.amount, 100)
                    XCTAssertEqual(transactionRequest.address, "ykql631634124896")
                    XCTAssertEqual(transactionRequest.correlationId, "wjkehfwjjwbgb")
                    XCTAssertEqual(transactionRequest.status, .valid)
                    XCTAssertEqual(transactionRequest.socketTopic, "transaction_request:txr_01cs9aq1868a2qdyee06w2xvbf")
                    XCTAssertFalse(transactionRequest.requireConfirmation)
                    XCTAssertEqual(transactionRequest.maxConsumptions, 1)
                    XCTAssertEqual(transactionRequest.consumptionLifetime, 1000)
                    XCTAssertNil(transactionRequest.expirationDate)
                    XCTAssertNil(transactionRequest.expirationReason)
                    XCTAssertEqual(transactionRequest.createdAt, "2018-10-08T07:54:24Z".toDate(withFormat: "yyyy-MM-dd'T'HH:mm:ssZ"))
                    XCTAssertNil(transactionRequest.expiredAt)
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
