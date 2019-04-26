//
//  TransactionConsumptionAdminFixtureTests.swift
//  Tests
//
//  Created by Mederic Petit on 8/10/18.
//  Copyright © 2017-2019 Omise Go Pte. Ltd. All rights reserved.
//

import OmiseGO
import XCTest

class TransactionConsumptionAdminFixtureTests: FixtureAdminTestCase {
    func testConsumeTransactionRequest() {
        let expectation =
            self.expectation(description: "Consume a transaction request corresponding to the params provided")
        let transactionRequest = StubGenerator.transactionRequest(
            id: "txr_01cs9aq1868a2qdyee06w2xvbf",
            type: .receive,
            token: StubGenerator.token(id: "tok_TK1_01cs953xjn9hvz1bcet7swq36j"),
            amount: 100,
            address: "ykql631634124896",
            correlationId: "wjkehfwjjwbgb",
            status: .valid
        )
        let params = TransactionConsumptionParams(
            transactionRequest: transactionRequest,
            address: "pgjz791619968896",
            amount: nil,
            idempotencyToken: "wkjnfejwkqdwedqwngkjwneg",
            correlationId: "lkwmelkgmwwlekg",
            metadata: [:]
        )!
        let request =
            TransactionConsumption.consumeTransactionRequest(using: self.testClient, params: params) { result in
                defer { expectation.fulfill() }
                switch result {
                case let .success(data: transactionConsumption):
                    XCTAssertEqual(transactionConsumption.id, "txc_01cs9bb80wqd5xxrfyzgwazhqg")
                    XCTAssertEqual(transactionConsumption.status, .confirmed)
                    XCTAssertNil(transactionConsumption.amount)
                    let token = transactionConsumption.token
                    XCTAssertEqual(token.id, "tok_TK1_01cs953xjn9hvz1bcet7swq36j")
                    XCTAssertEqual(transactionConsumption.correlationId, "lkwmelkgmwerwlekg")
                    XCTAssertEqual(transactionConsumption.idempotencyToken, "wkjnfejwkqdwedqwngkjwneg")
                    let transaction = transactionConsumption.transaction!
                    XCTAssertEqual(transaction.id, "txn_01cs9bb815yf7mndaty8q3d7yj")
                    let account = transactionConsumption.account!
                    XCTAssertEqual(account.id, "acc_01cs94yc3x4gggm6pwq2fhh1kv")
                    XCTAssertNil(transactionConsumption.user)
                    let transactionRequest = transactionConsumption.transactionRequest
                    XCTAssertEqual(transactionRequest.id, "txr_01cs9aq1868a2qdyee06w2xvbf")
                    XCTAssertEqual(transactionConsumption.address, "pgjz791619968896")
                    XCTAssertEqual(transactionConsumption.createdAt, "2018-10-08T08:05:26Z".toDate())
                    XCTAssertTrue(transactionConsumption.metadata.isEmpty)
                case let .failure(error):
                    XCTFail("\(error)")
                }
            }
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }

    func testCancelTransactionConsumption() {
        let expectation =
            self.expectation(description: "Cancel a transaction consumption")
        let transactionConsumption = StubGenerator.transactionConsumption()
        let request = transactionConsumption.cancel(using: self.testClient) { result in
            defer { expectation.fulfill() }
            switch result {
            case let .success(data: transactionConsumption):
                XCTAssertEqual(transactionConsumption.status, .cancelled)
            case let .failure(error):
                XCTFail("\(error)")
            }
        }
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }

    func testApproveTransactionConsumption() {
        let expectation =
            self.expectation(description: "Confirm a transaction consumption")
        let transactionConsumption = StubGenerator.transactionConsumption()
        let request = transactionConsumption.approve(using: self.testClient) { result in
            defer { expectation.fulfill() }
            switch result {
            case let .success(data: transactionConsumption):
                XCTAssertEqual(transactionConsumption.id, "txc_01cs9bb80wqd5xxrfyzgwazhqg")
                XCTAssertEqual(transactionConsumption.status, .confirmed)
                XCTAssertNil(transactionConsumption.amount)
                let token = transactionConsumption.token
                XCTAssertEqual(token.id, "tok_TK1_01cs953xjn9hvz1bcet7swq36j")
                XCTAssertEqual(transactionConsumption.correlationId, "lkwmelkgmwerwlekg")
                XCTAssertEqual(transactionConsumption.idempotencyToken, "wkjnfejwkqdwedqwngkjwneg")
                let transaction = transactionConsumption.transaction!
                XCTAssertEqual(transaction.id, "txn_01cs9bb815yf7mndaty8q3d7yj")
                let account = transactionConsumption.account!
                XCTAssertEqual(account.id, "acc_01cs94yc3x4gggm6pwq2fhh1kv")
                XCTAssertNil(transactionConsumption.user)
                let transactionRequest = transactionConsumption.transactionRequest
                XCTAssertEqual(transactionRequest.id, "txr_01cs9aq1868a2qdyee06w2xvbf")
                XCTAssertEqual(transactionConsumption.address, "pgjz791619968896")
                XCTAssertEqual(transactionConsumption.createdAt, "2018-10-08T08:05:26Z".toDate())
                XCTAssertTrue(transactionConsumption.metadata.isEmpty)
            case let .failure(error):
                XCTFail("\(error)")
            }
        }
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }

    func testRejectTransactionConsumption() {
        let expectation =
            self.expectation(description: "Confirm a transaction consumption")
        let transactionConsumption = StubGenerator.transactionConsumption()
        let request = transactionConsumption.reject(using: self.testClient) { result in
            defer { expectation.fulfill() }
            switch result {
            case let .success(data: transactionConsumption):
                XCTAssertEqual(transactionConsumption.id, "txc_01cs9bb80wqd5xxrfyzgwazhqg")
                XCTAssertEqual(transactionConsumption.status, .rejected)
                XCTAssertNil(transactionConsumption.amount)
                let token = transactionConsumption.token
                XCTAssertEqual(token.id, "tok_TK1_01cs953xjn9hvz1bcet7swq36j")
                XCTAssertEqual(transactionConsumption.correlationId, "lkwmelkgmwerwlekg")
                XCTAssertEqual(transactionConsumption.idempotencyToken, "wkjnfejwkqdwedqwngkjwneg")
                let account = transactionConsumption.account!
                XCTAssertEqual(account.id, "acc_01cs94yc3x4gggm6pwq2fhh1kv")
                XCTAssertNil(transactionConsumption.user)
                let transactionRequest = transactionConsumption.transactionRequest
                XCTAssertEqual(transactionRequest.id, "txr_01cs9aq1868a2qdyee06w2xvbf")
                XCTAssertEqual(transactionConsumption.address, "pgjz791619968896")
                XCTAssertEqual(transactionConsumption.createdAt, "2018-10-08T08:05:26Z".toDate())
                XCTAssertTrue(transactionConsumption.metadata.isEmpty)
            case let .failure(error):
                XCTFail("\(error)")
            }
        }
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
}
