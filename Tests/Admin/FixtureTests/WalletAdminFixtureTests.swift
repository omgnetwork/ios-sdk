//
//  WalletAdminFixtureTests.swift
//  Tests
//
//  Created by Mederic Petit on 17/9/18.
//  Copyright © 2017-2019 Omise Go Pte. Ltd. All rights reserved.
//

import OmiseGO
import XCTest

class WalletAdminFixtureTests: FixtureAdminTestCase {
    func testGetFromAddress() {
        let expectation = self.expectation(description: "Get a wallet from its address")
        let address = "ixsz977823599563"
        let params = WalletGetParams(address: address)
        let request = Wallet.get(using: self.testClient, params: params) { result in
            defer { expectation.fulfill() }
            switch result {
            case let .success(data: wallet):
                XCTAssertEqual(wallet.address, address)
            case let .failure(error):
                XCTFail("\(error)")
            }
        }
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }

    func testGetListForUser() {
        let expectation = self.expectation(description: "Get wallets for a specific user")
        let userId = "usr_01cq97a3hgm49h8tw28evv5bg2"
        let paginationParams: PaginatedListParams<Wallet> = PaginatedListParams<Wallet>(page: 1, perPage: 10, sortBy: .address, sortDirection: .ascending)
        let params = WalletListForUserParams(paginatedListParams: paginationParams, userId: userId)
        let request = Wallet.listForUser(using: self.testClient, params: params) { result in
            defer { expectation.fulfill() }
            switch result {
            case let .success(data: paginatedWallets):
                let wallets = paginatedWallets.data
                XCTAssertEqual(paginatedWallets.pagination.currentPage, 1)
                XCTAssertEqual(paginatedWallets.pagination.perPage, 10)
                XCTAssertTrue(paginatedWallets.pagination.isFirstPage)
                XCTAssertTrue(paginatedWallets.pagination.isLastPage)
                XCTAssertEqual(wallets.count, 2)
                XCTAssertEqual(wallets.first!.userId!, userId)
                XCTAssertEqual(wallets[1].userId!, userId)
            case let .failure(error):
                XCTFail("\(error)")
            }
        }
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }

    func testGetListForAccount() {
        let expectation = self.expectation(description: "Get wallets for a specific account")
        let accountId = "acc_01cnfz5sh5zmhx4xwd6m1rethy"
        let paginationParams: PaginatedListParams<Wallet> = PaginatedListParams<Wallet>(page: 1, perPage: 10, sortBy: .address, sortDirection: .ascending)
        let params = WalletListForAccountParams(paginatedListParams: paginationParams, accountId: accountId, owned: false)
        let request = Wallet.listForAccount(using: self.testClient, params: params) { result in
            defer { expectation.fulfill() }
            switch result {
            case let .success(data: paginatedWallets):
                let wallets = paginatedWallets.data
                XCTAssertEqual(paginatedWallets.pagination.currentPage, 1)
                XCTAssertEqual(paginatedWallets.pagination.perPage, 10)
                XCTAssertTrue(paginatedWallets.pagination.isFirstPage)
                XCTAssertTrue(paginatedWallets.pagination.isLastPage)
                XCTAssertEqual(wallets.count, 2)
                XCTAssertEqual(wallets.first!.accountId!, accountId)
                XCTAssertEqual(wallets[1].accountId!, accountId)
            case let .failure(error):
                XCTFail("\(error)")
            }
        }
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
}
