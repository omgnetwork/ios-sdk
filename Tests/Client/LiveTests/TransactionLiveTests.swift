//
//  TransactionLiveTests.swift
//  Tests
//
//  Created by Mederic Petit on 23/2/18.
//  Copyright © 2017-2019 Omise Go Pte. Ltd. All rights reserved.
//

import OmiseGO
import XCTest

class TransactionLiveTests: LiveClientTestCase {
    func testGetTransactionList() {
        let expectation = self.expectation(description: "Get paginated list of transactions")
        let paginationParams = PaginatedListParams<Transaction>(
            page: 1,
            perPage: 10,
            sortBy: .createdAt,
            sortDirection: .descending
        )
        let params = TransactionListParams(paginatedListParams: paginationParams, address: nil)
        let request = Transaction.list(
            using: self.testClient,
            params: params
        ) { result in
            defer { expectation.fulfill() }
            switch result {
            case let .success(paginatedList):
                XCTAssertEqual(paginatedList.pagination.currentPage, 1)
                XCTAssertTrue(paginatedList.pagination.isFirstPage)
            case let .failure(error):
                XCTFail("\(error)")
            }
        }
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
}
