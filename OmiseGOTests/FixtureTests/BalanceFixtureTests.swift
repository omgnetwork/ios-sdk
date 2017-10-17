//
//  BalanceFixtureTests.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 12/10/2560 BE.
//  Copyright © 2560 OmiseGO. All rights reserved.
//

import XCTest
@testable import OmiseGO

class BalanceFixtureTests: FixtureTestCase {

    let decimalSeparator = NSLocale.current.decimalSeparator ?? "."
    let groupingSeparator = NSLocale.current.groupingSeparator ?? ","

    func testGetAllBalances() {
        let expectation = self.expectation(description: "Balances result")
        let request = Balance.getAll(using: self.testCustomClient) { (result) in
            defer { expectation.fulfill() }
            switch result {
            case .success(let balances):
                XCTAssert(balances.count == 2)
                XCTAssertEqual(balances[0].address, "my_mnt_address")
                XCTAssertEqual(balances[0].amount, 10)
                XCTAssertEqual(balances[0].symbol, "MNT")
                XCTAssertEqual(balances[0].subUnitToUnit, 100000)
                XCTAssertEqual(balances[1].address, "my_omg_address")
                XCTAssertEqual(balances[1].amount, 52)
                XCTAssertEqual(balances[1].symbol, "OMG")
                XCTAssertEqual(balances[1].subUnitToUnit, 100000000)
            case .fail(let error):
                XCTFail("\(error)")
            }
        }
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }

    func testStandardDisplayAmount() {
        let balance1 = Balance(address: "", symbol: "", amount: 13, subUnitToUnit: 1000)
        XCTAssertEqual(balance1.displayAmount(), "0\(decimalSeparator)013")
    }

    func testZeroDisplayAmount() {
        let balance2 = Balance(address: "", symbol: "", amount: 0, subUnitToUnit: 1000)
        XCTAssertEqual(balance2.displayAmount(), "0")
    }

    func testBigDisplayAmount() {
        let balance3 = Balance(address: "", symbol: "", amount: 999999999999999, subUnitToUnit: 1000)
        XCTAssertEqual(balance3.displayAmount(),
                       "999\(groupingSeparator)999\(groupingSeparator)999\(groupingSeparator)999\(decimalSeparator)999")
    }

    func testBigDisplayAmountWithBigSubUnitToUnity() {
        let balance4 = Balance(address: "", symbol: "", amount: 130000000000000000000,
                               subUnitToUnit: 1000000000000000000)
        XCTAssertEqual(balance4.displayAmount(), "130")
    }

    func testSmallestDisplayAmount() {
        let balance5 = Balance(address: "", symbol: "", amount: 1, subUnitToUnit: 1000000000000000000)
        XCTAssertEqual(balance5.displayAmount(), "0\(decimalSeparator)000000000000000001")
    }

}
