//
//  BalanceFixtureTests.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 12/10/2560 BE.
//  Copyright © 2560 OmiseGO. All rights reserved.
//

import XCTest
import OmiseGO

class BalanceFixtureTests: FixtureTestCase {

    func testGetAllBalances() {
        let expectation = self.expectation(description: "Balances result")
        let request = Balance.getAll(using: self.testCustomClient) { (result) in
            defer { expectation.fulfill() }
            switch result {
            case .success(let balances):
                XCTAssert(balances.count == 2)
                XCTAssertEqual(balances[0].object, "balance")
                XCTAssertEqual(balances[0].address, "my_mnt_address")
                XCTAssertEqual(balances[0].amount, 10)
                XCTAssertEqual(balances[0].symbol, "MNT")
                XCTAssertEqual(balances[1].object, "balance")
                XCTAssertEqual(balances[1].address, "my_omg_address")
                XCTAssertEqual(balances[1].amount, 52)
                XCTAssertEqual(balances[1].symbol, "OMG")
            case .fail(let error):
                XCTFail("\(error)")
            }
        }
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }

}
