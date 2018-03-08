//
//  TransactionFixtureTests.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 23/2/18.
//  Copyright © 2018 OmiseGO. All rights reserved.
//

import XCTest
import OmiseGO

class TransactionFixtureTests: FixtureTestCase {

    //swiftlint:disable:next function_body_length
    func testGetListOfTransactions() {
        let expectation =
            self.expectation(description: "Get the list of transactions for the current user")
        let paginationParams = PaginationParams<Transaction>(page: 1,
                                                             perPage: 10,
                                                             searchTerm: nil,
                                                             searchTerms: nil,
                                                             sortBy: .to,
                                                             sortDirection: .ascending)
        let params = TransactionListParams(paginationParams: paginationParams, address: nil)

        let request =
            Transaction.list(using: self.testCustomClient, params: params) { (result) in
                defer { expectation.fulfill() }
                switch result {
                case .success(data: let paginatedList):
                    let transactions = paginatedList.data
                    let transaction = transactions.first!
                    XCTAssertEqual(transaction.id, "ce3982f5-4a27-498d-a91b-7bb2e2a8d3d1")
                    let from = transaction.from
                    XCTAssertEqual(from.address, "1e3982f5-4a27-498d-a91b-7bb2e2a8d3d1")
                    let fromMintedToken = from.mintedToken
                    XCTAssertEqual(fromMintedToken.id, "BTC:xe3982f5-4a27-498d-a91b-7bb2e2a8d3d1")
                    XCTAssertEqual(fromMintedToken.symbol, "BTC")
                    XCTAssertEqual(fromMintedToken.name, "Bitcoin")
                    XCTAssertEqual(fromMintedToken.subUnitToUnit, 100)
                    let to = transaction.to
                    XCTAssertEqual(to.address, "2e3982f5-4a27-498d-a91b-7bb2e2a8d3d1")
                    let toMintedToken = to.mintedToken
                    XCTAssertEqual(toMintedToken.id, "BTC:xe3982f5-4a27-498d-a91b-7bb2e2a8d3d1")
                    XCTAssertEqual(toMintedToken.symbol, "BTC")
                    XCTAssertEqual(toMintedToken.name, "Bitcoin")
                    XCTAssertEqual(toMintedToken.subUnitToUnit, 100)
                    let exchange = transaction.exchange
                    XCTAssertEqual(exchange.rate, 1)
                    XCTAssertEqual(transaction.status, .confirmed)
                    XCTAssertEqual(transaction.metadata.count, 0)
                    XCTAssertEqual(transaction.createdAt, "2018-01-01T00:00:00Z".toDate())
                    XCTAssertEqual(transaction.updatedAt, "2018-01-01T10:00:00Z".toDate())
                case .fail(error: let error):
                    XCTFail("\(error)")
                }
        }
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }

}
