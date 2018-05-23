//
//  WalletFixtureTests.swift
//  OmiseGOTests
//
//  Created by Thibault Denizet on 11/10/2017.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

import XCTest
import OmiseGO

class WalletFixtureTests: FixtureTestCase {

    func testGetAll() {
        let expectation = self.expectation(description: "Get all wallets for current user")
        let request = Wallet.getAll(using: self.testClient) { (result) in
            defer { expectation.fulfill() }
            switch result {
            case .success(data: let wallets):
                XCTAssertEqual(wallets.count, 1)
                let wallet = wallets.first!
                XCTAssertEqual(wallet.address, "2c2e0f2e-fa0f-4abe-8516-9e92cf003486")

                XCTAssertEqual(wallet.balances.count, 2)
                let balance1 = wallet.balances[0]
                let balance2 = wallet.balances[1]

                XCTAssertEqual(balance1.amount, 103100)
                XCTAssertEqual(balance1.token.id, "OMG:123")
                XCTAssertEqual(balance1.token.symbol, "OMG")
                XCTAssertEqual(balance1.token.subUnitToUnit, 10000)
                XCTAssertTrue(balance1.token.metadata.isEmpty)
                XCTAssertTrue(balance1.token.encryptedMetadata.isEmpty)
                XCTAssertEqual(balance1.token.createdAt, "2018-01-01T00:00:00Z".toDate())
                XCTAssertEqual(balance1.token.updatedAt, "2018-01-01T00:00:00Z".toDate())

                XCTAssertEqual(balance2.amount, 133700)
                XCTAssertEqual(balance2.token.id, "KNC:123")
                XCTAssertEqual(balance2.token.symbol, "KNC")
                XCTAssertEqual(balance2.token.subUnitToUnit, 10000)
                XCTAssertTrue(balance2.token.metadata.isEmpty)
                XCTAssertTrue(balance2.token.encryptedMetadata.isEmpty)
                XCTAssertEqual(balance2.token.createdAt, "2018-01-01T00:00:00Z".toDate())
                XCTAssertEqual(balance2.token.updatedAt, "2018-01-01T00:00:00Z".toDate())
            case .fail(error: let error):
                XCTFail("\(error)")
            }
        }
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }

    func testGetMain() {
        let expectation = self.expectation(description: "Get the main address of the current user")
        let request = Wallet.getMain(using: self.testClient) { (result) in
            defer { expectation.fulfill() }
            switch result {
            case .success(data: let wallet):
                XCTAssertEqual(wallet.address, "2c2e0f2e-fa0f-4abe-8516-9e92cf003486")

                XCTAssertEqual(wallet.balances.count, 2)
                let balance1 = wallet.balances[0]
                let balance2 = wallet.balances[1]

                XCTAssertEqual(balance1.amount, 103100)
                XCTAssertEqual(balance1.token.id, "OMG:123")
                XCTAssertEqual(balance1.token.symbol, "OMG")
                XCTAssertEqual(balance1.token.subUnitToUnit, 10000)
                XCTAssertTrue(balance1.token.metadata.isEmpty)
                XCTAssertTrue(balance1.token.encryptedMetadata.isEmpty)
                XCTAssertEqual(balance1.token.createdAt, "2018-01-01T00:00:00Z".toDate())
                XCTAssertEqual(balance1.token.updatedAt, "2018-01-01T00:00:00Z".toDate())

                XCTAssertEqual(balance2.amount, 133700)
                XCTAssertEqual(balance2.token.id, "KNC:123")
                XCTAssertEqual(balance2.token.symbol, "KNC")
                XCTAssertEqual(balance2.token.subUnitToUnit, 10000)
                XCTAssertTrue(balance2.token.metadata.isEmpty)
                XCTAssertTrue(balance2.token.encryptedMetadata.isEmpty)
                XCTAssertEqual(balance2.token.createdAt, "2018-01-01T00:00:00Z".toDate())
                XCTAssertEqual(balance2.token.updatedAt, "2018-01-01T00:00:00Z".toDate())
            case .fail(error: let error):
                XCTFail("\(error)")
            }
        }
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
}
