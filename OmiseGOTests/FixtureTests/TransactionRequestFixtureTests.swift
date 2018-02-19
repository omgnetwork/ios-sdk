//
//  TransactionRequestFixtureTests.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 5/2/2561 BE.
//  Copyright © 2561 OmiseGO. All rights reserved.
//

import XCTest
@testable import OmiseGO

class TransactionRequestFixtureTests: FixtureTestCase {

    func testGenerateTransactionRequest() {
        let expectation =
            self.expectation(description: "Generate a transaction request corresponding to the params provided")
        let params = StubGenerator.transactionRequestCreateParams(
                type: .receive,
                mintedTokenId: "BTC:861020af-17b6-49ee-a0cb-661a4d2d1f95",
                amount: 1337,
                address: "3b7f1c68-e3bd-4f8f-9916-4af19be95d00",
                correlationId: "31009545-db10-4287-82f4-afb46d9741d8")
        let request =
            TransactionRequest.generateTransactionRequest(using: self.testCustomClient, params: params) { (result) in
                defer { expectation.fulfill() }
                switch result {
                case .success(data: let transactionRequest):
                    XCTAssertEqual(transactionRequest.id, "8eb0160e-1c96-481a-88e1-899399cc84dc")
                    XCTAssertEqual(transactionRequest.mintedTokenId, "BTC:861020af-17b6-49ee-a0cb-661a4d2d1f95")
                    XCTAssertEqual(transactionRequest.amount, 1337)
                    XCTAssertEqual(transactionRequest.address, "3b7f1c68-e3bd-4f8f-9916-4af19be95d00")
                    XCTAssertEqual(transactionRequest.correlationId, "31009545-db10-4287-82f4-afb46d9741d8")
                case .fail(error: let error):
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
            TransactionRequest.retrieveTransactionRequest(
                using: self.testCustomClient,
                id: "8eb0160e-1c96-481a-88e1-899399cc84dc") { (result) in
                    defer { expectation.fulfill() }
                    switch result {
                    case .success(data: let transactionRequest):
                        XCTAssertEqual(transactionRequest.id, "8eb0160e-1c96-481a-88e1-899399cc84dc")
                        XCTAssertEqual(transactionRequest.mintedTokenId, "BTC:861020af-17b6-49ee-a0cb-661a4d2d1f95")
                        XCTAssertEqual(transactionRequest.amount, 1337)
                        XCTAssertEqual(transactionRequest.address, "3b7f1c68-e3bd-4f8f-9916-4af19be95d00")
                        XCTAssertEqual(transactionRequest.correlationId, "31009545-db10-4287-82f4-afb46d9741d8")
                    case .fail(error: let error):
                        XCTFail("\(error)")
                    }
        }
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }

}
