//
//  TransactionConsumeFixtureTests.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 13/2/2018 BE.
//  Copyright © 2018 OmiseGO. All rights reserved.
//

import XCTest
@testable import OmiseGO

class TransactionConsumeFixtureTests: FixtureTestCase {

    func testConsumeTransactionRequest() {
        let expectation =
            self.expectation(description: "Consume a transaction request corresponding to the params provided")
        let transactionRequest = StubGenerator.transactionRequest(
                id: "0a8a4a98-794b-419e-b92d-514e83657e75",
                type: .receive,
                mintedTokenId: "BTC:5ee328ec-b9e2-46a5-88bb-c8b15ea6b3c1",
                amount: 1337,
                address: "3bfe0ff7-f43e-4ac6-bdf9-c4a290c40d0d",
                correlationId: "31009545-db10-4287-82f4-afb46d9741d8",
                status: .valid)
        let params = TransactionConsumeParams(
                transactionRequest: transactionRequest,
                address: nil,
                idempotencyToken: "123",
                correlationId: nil,
                metadata: [:])!
        let request =
            TransactionConsume.consumeTransactionRequest(using: self.testCustomClient, params: params) { (result) in
                defer { expectation.fulfill() }
                switch result {
                case .success(data: let transactionConsume):
                    XCTAssertEqual(transactionConsume.id, "8eb0160e-1c96-481a-88e1-899399cc84dc")
                    let mintedToken = transactionConsume.mintedToken
                    XCTAssertEqual(mintedToken.id, "BTC:123")
                    XCTAssertEqual(mintedToken.symbol, "BTC")
                    XCTAssertEqual(mintedToken.name, "Bitcoin")
                    XCTAssertEqual(mintedToken.subUnitToUnit, 100000)
                    XCTAssertEqual(transactionConsume.amount, 1337)
                    XCTAssertEqual(transactionConsume.address, "3b7f1c68-e3bd-4f8f-9916-4af19be95d00")
                    XCTAssertEqual(transactionConsume.correlationId, "31009545-db10-4287-82f4-afb46d9741d8")
                    XCTAssertEqual(transactionConsume.idempotencyToken, "31009545-db10-4287-82f4-afb46d9741d8")
                    XCTAssertEqual(transactionConsume.transferId, "6ca40f34-6eaa-43e1-b2e1-a94ff3660988")
                    XCTAssertEqual(transactionConsume.userId, "6f56efa1-caf9-4348-8e0f-f5af283f17ee")
                    XCTAssertEqual(transactionConsume.transactionRequestId, "907056a4-fc2d-47cb-af19-5e73aade7ece")
                    XCTAssertEqual(transactionConsume.status, .confirmed)
                case .fail(error: let error):
                    XCTFail("\(error)")
                }
        }
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }

}
