//
//  TransactionAdminFixtureTests.swift
//  Tests
//
//  Created by Mederic Petit on 19/9/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import OmiseGO
import XCTest

class TransactionAdminFixtureTests: FixtureAdminTestCase {
    func testGetListOfTransactions() {
        let expectation = self.expectation(description: "Get the list of transactions")
        let params = PaginatedListParams<Transaction>(page: 1,
                                                      perPage: 10,
                                                      sortBy: .to,
                                                      sortDirection: .ascending)
        let request =
            Transaction.list(using: self.testClient, params: params) { result in
                defer { expectation.fulfill() }
                switch result {
                case let .success(data: paginatedList):
                    let transactions = paginatedList.data
                    XCTAssertEqual(transactions.first?.id, "txn_01cqr309xnwa2qwdk4dqaqrbs6")
                    XCTAssertEqual(transactions[1].id, "txn_01cqr2yx2ns2kdysat3h7075a0")
                case let .fail(error: error):
                    XCTFail("\(error)")
                }
            }
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
}
