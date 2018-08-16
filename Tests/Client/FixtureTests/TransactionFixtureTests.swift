//
//  TransactionFixtureTests.swift
//  Tests
//
//  Created by Mederic Petit on 23/2/18.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

import OmiseGO
import XCTest

class TransactionFixtureTests: FixtureClientTestCase {
    // swiftlint:disable:next function_body_length
    func testGetListOfTransactions() {
        let expectation =
            self.expectation(description: "Get the list of transactions for the current user")
        let paginationParams = PaginationParams<Transaction>(page: 1,
                                                             perPage: 10,
                                                             searchTerm: nil,
                                                             sortBy: .to,
                                                             sortDirection: .ascending)
        let params = TransactionListParams(paginationParams: paginationParams, address: nil)

        let request =
            Transaction.list(using: self.testClient, params: params) { result in
                defer { expectation.fulfill() }
                switch result {
                case let .success(data: paginatedList):
                    let transactions = paginatedList.data
                    let transaction = transactions.first!
                    XCTAssertEqual(transaction.id, "ce3982f5-4a27-498d-a91b-7bb2e2a8d3d1")
                    let from = transaction.from
                    XCTAssertEqual(from.address, "1e3982f5-4a27-498d-a91b-7bb2e2a8d3d1")
                    let fromToken = from.token
                    XCTAssertEqual(fromToken.id, "BTC:xe3982f5-4a27-498d-a91b-7bb2e2a8d3d1")
                    XCTAssertEqual(fromToken.symbol, "BTC")
                    XCTAssertEqual(fromToken.name, "Bitcoin")
                    XCTAssertEqual(fromToken.subUnitToUnit, 100)
                    let to = transaction.to
                    XCTAssertEqual(to.address, "2e3982f5-4a27-498d-a91b-7bb2e2a8d3d1")
                    let toToken = to.token
                    XCTAssertEqual(toToken.id, "BTC:xe3982f5-4a27-498d-a91b-7bb2e2a8d3d1")
                    XCTAssertEqual(toToken.symbol, "BTC")
                    XCTAssertEqual(toToken.name, "Bitcoin")
                    XCTAssertEqual(toToken.subUnitToUnit, 100)
                    let exchange = transaction.exchange
                    XCTAssertEqual(exchange.rate, 1)
                    XCTAssertEqual(transaction.status, .confirmed)
                    XCTAssertTrue(transaction.metadata.isEmpty)
                    XCTAssertTrue(transaction.encryptedMetadata.isEmpty)
                    XCTAssertEqual(transaction.createdAt, "2018-01-01T00:00:00Z".toDate())
                case let .fail(error: error):
                    XCTFail("\(error)")
                }
            }
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }

    func testCreateTransaction() {
        let expectation = self.expectation(description: "Generate a transaction")
        let params = TransactionCreateParams(fromAddress: "1e3982f5-4a27-498d-a91b-7bb2e2a8d3d1",
                                             toAddress: "2e3982f5-4a27-498d-a91b-7bb2e2a8d3d1",
                                             amount: 1000,
                                             tokenId: "BTC:xe3982f5-4a27-498d-a91b-7bb2e2a8d3d1",
                                             idempotencyToken: "123")
        let request = Transaction.create(using: self.testClient, params: params) { result in
            defer { expectation.fulfill() }
            switch result {
            case let .success(data: transaction):
                XCTAssertEqual(transaction.id, "ce3982f5-4a27-498d-a91b-7bb2e2a8d3d1")
                let from = transaction.from
                XCTAssertEqual(from.address, "1e3982f5-4a27-498d-a91b-7bb2e2a8d3d1")
                let fromToken = from.token
                XCTAssertEqual(fromToken.id, "BTC:xe3982f5-4a27-498d-a91b-7bb2e2a8d3d1")
                XCTAssertEqual(fromToken.symbol, "BTC")
                XCTAssertEqual(fromToken.name, "Bitcoin")
                XCTAssertEqual(fromToken.subUnitToUnit, 100)
                let to = transaction.to
                XCTAssertEqual(to.address, "2e3982f5-4a27-498d-a91b-7bb2e2a8d3d1")
                let toToken = to.token
                XCTAssertEqual(toToken.id, "BTC:xe3982f5-4a27-498d-a91b-7bb2e2a8d3d1")
                XCTAssertEqual(toToken.symbol, "BTC")
                XCTAssertEqual(toToken.name, "Bitcoin")
                XCTAssertEqual(toToken.subUnitToUnit, 100)
                let exchange = transaction.exchange
                XCTAssertEqual(exchange.rate, 1)
                XCTAssertEqual(transaction.status, .confirmed)
                XCTAssertTrue(transaction.metadata.isEmpty)
                XCTAssertTrue(transaction.encryptedMetadata.isEmpty)
                XCTAssertEqual(transaction.createdAt, "2018-01-01T00:00:00Z".toDate())
            case let .fail(error: error):
                XCTFail("\(error)")
            }
        }
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
}
