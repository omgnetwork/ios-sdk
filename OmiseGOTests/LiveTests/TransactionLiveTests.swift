//
//  TransactionLiveTests.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 23/2/18.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

import OmiseGO
import XCTest

class TransactionLiveTests: LiveTestCase {
    func testGetTransactionList() {
        let expectation = self.expectation(description: "Get paginated list of transactions")
        let paginationParams = PaginationParams<Transaction>(
            page: 1,
            perPage: 10,
            searchTerm: nil,
            sortBy: .createdAt,
            sortDirection: .descending)
        let params = TransactionListParams(paginationParams: paginationParams, address: nil)
        let request = Transaction.list(
            using: self.testClient,
            params: params) { result in
            defer { expectation.fulfill() }
            switch result {
            case let .success(paginatedList):
                XCTAssertEqual(paginatedList.pagination.currentPage, 1)
                XCTAssertTrue(paginatedList.pagination.isFirstPage)
            case let .fail(error):
                XCTFail("\(error)")
            }
        }
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
}
