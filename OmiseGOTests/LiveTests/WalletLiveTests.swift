//
//  WalletLiveTests.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 10/11/2017.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

import XCTest
import OmiseGO

class WalletLiveTests: LiveTestCase {

    func testGetAll() {
        let expectation = self.expectation(description: "Get the list of wallets")
        let request = Wallet.getAll(using: self.testClient) { (result) in
            defer { expectation.fulfill() }
            switch result {
            case .success(data: let addresses):
                XCTAssert(!addresses.isEmpty)
            case .fail(error: let error):
                XCTFail("\(error)")
            }
        }
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }

    func testGetMain() {
        let expectation = self.expectation(description: "Get the main wallet")
        let request = Wallet.getMain(using: self.testClient) { (result) in
            defer { expectation.fulfill() }
            switch result {
            case .success(data: _):
                XCTAssertTrue(true)
            case .fail(error: let error):
                XCTFail("\(error)")
            }
        }
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }

}
