//
//  TransactionTests.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 23/2/18.
//  Copyright © 2018 OmiseGO. All rights reserved.
//

import XCTest
import OmiseGO

class TransactionTests: FixtureTestCase {

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
                    XCTAssertEqual(transactions.count, 1)
                    let transaction = transactions.first!
                    XCTAssertEqual(transaction.id, "ce3982f5-4a27-498d-a91b-7bb2e2a8d3d1")
                    XCTAssertEqual(transaction.amount, 1000)
                    XCTAssertEqual(transaction.from, "1e3982f5-4a27-498d-a91b-7bb2e2a8d3d1")
                    XCTAssertEqual(transaction.to, "2e3982f5-4a27-498d-a91b-7bb2e2a8d3d1")
                    let mintedToken = transaction.mintedToken
                    XCTAssertEqual(mintedToken.id, "BTC:xe3982f5-4a27-498d-a91b-7bb2e2a8d3d1")
                    XCTAssertEqual(mintedToken.symbol, "BTC")
                    XCTAssertEqual(mintedToken.name, "Bitcoin")
                    XCTAssertEqual(mintedToken.subUnitToUnit, 100)
                    XCTAssertEqual(transaction.status, .confirmed)
                    XCTAssertEqual(transaction.createdAt, "2018-01-01T00:00:00Z".toDate())
                    XCTAssertEqual(transaction.updatedAt, "2018-01-01T10:00:00Z".toDate())
                    let pagination = paginatedList.pagination
                    XCTAssertEqual(pagination.currentPage, 1)
                    XCTAssertEqual(pagination.perPage, 10)
                    XCTAssertEqual(pagination.isFirstPage, true)
                    XCTAssertEqual(pagination.isLastPage, true)
                case .fail(error: let error):
                    XCTFail("\(error)")
                }
        }
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }

}
