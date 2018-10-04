//
//  AccountAdminFixtureTests.swift
//  Tests
//
//  Created by Mederic Petit on 18/9/18.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

import OmiseGO
import XCTest

class AccountAdminFixtureTests: FixtureAdminTestCase {
    func testGetListOfAccounts() {
        let expectation = self.expectation(description: "List accounts")
        let params: PaginatedListParams<Account> = PaginatedListParams<Account>(page: 1, perPage: 10, sortBy: .name, sortDirection: .ascending)
        let request = Account.list(using: self.testClient, params: params) { result in
            defer { expectation.fulfill() }
            switch result {
            case let .success(data: paginatedAccounts):
                let accounts = paginatedAccounts.data
                XCTAssertEqual(paginatedAccounts.pagination.currentPage, 1)
                XCTAssertEqual(paginatedAccounts.pagination.perPage, 10)
                XCTAssertTrue(paginatedAccounts.pagination.isFirstPage)
                XCTAssertTrue(paginatedAccounts.pagination.isLastPage)
                XCTAssertEqual(accounts.count, 2)
                XCTAssertEqual(accounts.first!.id, "acc_01cnfz5sh5zmhx4xwd6m1rethy")
                XCTAssertEqual(accounts[1].id, "acc_01cnnna53f35n80pnmbf730s29")
            case let .fail(error: error):
                XCTFail("\(error)")
            }
        }
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }

    func testGetAccount() {
        let expectation = self.expectation(description: "Get an account from its id")
        let params = AccountGetParams(id: "acc_01cnfz5sh5zmhx4xwd6m1rethy")
        let request = Account.get(using: self.testClient, params: params) { result in
            defer { expectation.fulfill() }
            switch result {
            case let .success(data: account):
                XCTAssertEqual(account.id, "acc_01cnfz5sh5zmhx4xwd6m1rethy")
            case let .fail(error: error):
                XCTFail("\(error)")
            }
        }
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
}
