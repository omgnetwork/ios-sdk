//
//  WalletAdminFixtureTests.swift
//  Tests
//
//  Created by Mederic Petit on 17/9/18.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
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
            case let .fail(error: error):
                XCTFail("\(error)")
            }
        }
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
}
