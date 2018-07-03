//
//  TransactionConsumptionFixtureTests.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 13/2/2018.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

import OmiseGO
import XCTest

class TransactionConsumptionFixtureTests: FixtureTestCase {
    func testConsumeTransactionRequest() {
        let expectation =
            self.expectation(description: "Consume a transaction request corresponding to the params provided")
        let transactionRequest = StubGenerator.transactionRequest(
            id: "0a8a4a98-794b-419e-b92d-514e83657e75",
            type: .receive,
            token: StubGenerator.token(id: "BTC:5ee328ec-b9e2-46a5-88bb-c8b15ea6b3c1"),
            amount: 1337,
            address: "3bfe0ff7-f43e-4ac6-bdf9-c4a290c40d0d",
            correlationId: "31009545-db10-4287-82f4-afb46d9741d8",
            status: .valid)
        let params = TransactionConsumptionParams(
            transactionRequest: transactionRequest,
            address: nil,
            amount: nil,
            idempotencyToken: "123",
            correlationId: nil,
            metadata: [:])!
        let request =
            TransactionConsumption.consumeTransactionRequest(using: self.testClient, params: params) { result in
                defer { expectation.fulfill() }
                switch result {
                case let .success(data: transactionConsumption):
                    XCTAssertEqual(transactionConsumption.id, "8eb0160e-1c96-481a-88e1-899399cc84dc")
                    XCTAssertEqual(transactionConsumption.status, .confirmed)
                    XCTAssertEqual(transactionConsumption.amount, 1337)
                    let token = transactionConsumption.token
                    XCTAssertEqual(token.id, "BTC:861020af-17b6-49ee-a0cb-661a4d2d1f95")
                    XCTAssertEqual(token.symbol, "BTC")
                    XCTAssertEqual(token.name, "Bitcoin")
                    XCTAssertEqual(token.subUnitToUnit, 100_000)
                    XCTAssertEqual(transactionConsumption.correlationId, "31009545-db10-4287-82f4-afb46d9741d8")
                    XCTAssertEqual(transactionConsumption.idempotencyToken, "31009545-db10-4287-82f4-afb46d9741d8")
                    let transaction = transactionConsumption.transaction!
                    XCTAssertEqual(transaction.id, "6ca40f34-6eaa-43e1-b2e1-a94ff366098")
                    let user = transactionConsumption.user!
                    XCTAssertEqual(user.id, "6f56efa1-caf9-4348-8e0f-f5af283f17ee")
                    XCTAssertNil(transactionConsumption.account)
                    let transactionRequest = transactionConsumption.transactionRequest
                    XCTAssertEqual(transactionRequest.id, "907056a4-fc2d-47cb-af19-5e73aade7ece")
                    XCTAssertEqual(transactionConsumption.address, "3b7f1c68-e3bd-4f8f-9916-4af19be95d00")
                    XCTAssertEqual(transactionConsumption.socketTopic, "transaction_consumption:8eb0160e-1c96-481a-88e1-899399cc84dc")
                    XCTAssertEqual(transactionConsumption.expirationDate, "2019-01-01T00:00:00Z".toDate())
                    XCTAssertEqual(transactionConsumption.approvedAt, nil)
                    XCTAssertEqual(transactionConsumption.rejectedAt, nil)
                    XCTAssertEqual(transactionConsumption.confirmedAt, nil)
                    XCTAssertEqual(transactionConsumption.failedAt, nil)
                    XCTAssertEqual(transactionConsumption.expiredAt, nil)
                    XCTAssertEqual(transactionConsumption.createdAt, "2018-01-01T00:00:00Z".toDate())
                    XCTAssertTrue(transactionConsumption.metadata.isEmpty)
                case let .fail(error: error):
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
                XCTAssertEqual(transactionConsumption.id, "8eb0160e-1c96-481a-88e1-899399cc84dc")
                XCTAssertEqual(transactionConsumption.status, .confirmed)
                XCTAssertEqual(transactionConsumption.amount, 1337)
                let token = transactionConsumption.token
                XCTAssertEqual(token.id, "BTC:861020af-17b6-49ee-a0cb-661a4d2d1f95")
                XCTAssertEqual(token.symbol, "BTC")
                XCTAssertEqual(token.name, "Bitcoin")
                XCTAssertEqual(token.subUnitToUnit, 100_000)
                XCTAssertEqual(transactionConsumption.correlationId, "31009545-db10-4287-82f4-afb46d9741d8")
                XCTAssertEqual(transactionConsumption.idempotencyToken, "31009545-db10-4287-82f4-afb46d9741d8")
                let transaction = transactionConsumption.transaction!
                XCTAssertEqual(transaction.id, "6ca40f34-6eaa-43e1-b2e1-a94ff366098")
                let user = transactionConsumption.user!
                XCTAssertEqual(user.id, "6f56efa1-caf9-4348-8e0f-f5af283f17ee")
                XCTAssertNil(transactionConsumption.account)
                let transactionRequest = transactionConsumption.transactionRequest
                XCTAssertEqual(transactionRequest.id, "907056a4-fc2d-47cb-af19-5e73aade7ece")
                XCTAssertEqual(transactionConsumption.address, "3b7f1c68-e3bd-4f8f-9916-4af19be95d00")
                XCTAssertEqual(transactionConsumption.socketTopic, "transaction_consumption:8eb0160e-1c96-481a-88e1-899399cc84dc")
                XCTAssertEqual(transactionConsumption.expirationDate, "2019-01-01T00:00:00Z".toDate())
                XCTAssertEqual(transactionConsumption.approvedAt, "2018-01-02T00:00:00Z".toDate())
                XCTAssertEqual(transactionConsumption.rejectedAt, nil)
                XCTAssertEqual(transactionConsumption.confirmedAt, "2019-01-02T00:00:00Z".toDate())
                XCTAssertEqual(transactionConsumption.failedAt, nil)
                XCTAssertEqual(transactionConsumption.expiredAt, nil)
                XCTAssertEqual(transactionConsumption.createdAt, "2018-01-01T00:00:00Z".toDate())
                XCTAssertTrue(transactionConsumption.metadata.isEmpty)
            case let .fail(error: error):
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
                XCTAssertEqual(transactionConsumption.id, "8eb0160e-1c96-481a-88e1-899399cc84dc")
                XCTAssertEqual(transactionConsumption.status, .rejected)
                XCTAssertEqual(transactionConsumption.amount, 1337)
                let token = transactionConsumption.token
                XCTAssertEqual(token.id, "BTC:861020af-17b6-49ee-a0cb-661a4d2d1f95")
                XCTAssertEqual(token.symbol, "BTC")
                XCTAssertEqual(token.name, "Bitcoin")
                XCTAssertEqual(token.subUnitToUnit, 100_000)
                XCTAssertEqual(transactionConsumption.correlationId, "31009545-db10-4287-82f4-afb46d9741d8")
                XCTAssertEqual(transactionConsumption.idempotencyToken, "31009545-db10-4287-82f4-afb46d9741d8")
                XCTAssertNil(transactionConsumption.transaction)
                let user = transactionConsumption.user!
                XCTAssertEqual(user.id, "6f56efa1-caf9-4348-8e0f-f5af283f17ee")
                XCTAssertNil(transactionConsumption.account)
                let transactionRequest = transactionConsumption.transactionRequest
                XCTAssertEqual(transactionRequest.id, "907056a4-fc2d-47cb-af19-5e73aade7ece")
                XCTAssertEqual(transactionConsumption.address, "3b7f1c68-e3bd-4f8f-9916-4af19be95d00")
                XCTAssertEqual(transactionConsumption.socketTopic, "transaction_consumption:8eb0160e-1c96-481a-88e1-899399cc84dc")
                XCTAssertEqual(transactionConsumption.expirationDate, "2019-01-01T00:00:00Z".toDate())
                XCTAssertEqual(transactionConsumption.approvedAt, nil)
                XCTAssertEqual(transactionConsumption.rejectedAt, "2018-01-02T00:00:00Z".toDate())
                XCTAssertEqual(transactionConsumption.confirmedAt, "2019-01-02T00:00:00Z".toDate())
                XCTAssertEqual(transactionConsumption.failedAt, nil)
                XCTAssertEqual(transactionConsumption.expiredAt, nil)
                XCTAssertEqual(transactionConsumption.createdAt, "2018-01-01T00:00:00Z".toDate())
                XCTAssertTrue(transactionConsumption.metadata.isEmpty)
                XCTAssertTrue(transactionConsumption.encryptedMetadata.isEmpty)
            case let .fail(error: error):
                XCTFail("\(error)")
            }
        }
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
}
