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
                let mntToken = balances[0].mintedToken
                XCTAssertEqual(mntToken.symbol, "MNT")
                XCTAssertEqual(mntToken.subUnitToUnit, 100000)
                XCTAssertEqual(balances[0].address, "my_mnt_address")
                XCTAssertEqual(balances[0].amount, 10)
                let omgToken = balances[1].mintedToken
                XCTAssertEqual(omgToken.symbol, "OMG")
                XCTAssertEqual(omgToken.subUnitToUnit, 100000000)
                XCTAssertEqual(balances[1].address, "my_omg_address")
                XCTAssertEqual(balances[1].amount, 52)
            case .fail(let error):
                XCTFail("\(error)")
            }
        }
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }

    func testStandardDisplayAmount() {
        let mintedToken = MintedToken(symbol: "", name: "", subUnitToUnit: 1000)
        let balance = Balance(mintedToken: mintedToken, address: "", amount: 13)
        XCTAssertEqual(balance.displayAmount(), "0\(decimalSeparator)013")
    }

    func testZeroDisplayAmount() {
        let mintedToken = MintedToken(symbol: "", name: "", subUnitToUnit: 1000)
        let balance = Balance(mintedToken: mintedToken, address: "", amount: 0)
        XCTAssertEqual(balance.displayAmount(), "0")
    }

    func testBigDisplayAmount() {
        let mintedToken = MintedToken(symbol: "", name: "", subUnitToUnit: 1000)
        let balance = Balance(mintedToken: mintedToken, address: "", amount: 999999999999999)
        XCTAssertEqual(balance.displayAmount(),
                       "999\(groupingSeparator)999\(groupingSeparator)999\(groupingSeparator)999\(decimalSeparator)999")
    }

    func testBigDisplayAmountPrecision() {
        let mintedToken = MintedToken(symbol: "", name: "", subUnitToUnit: 1000)
        let balance = Balance(mintedToken: mintedToken, address: "", amount: 999999999999999)
        XCTAssertEqual(balance.displayAmount(withPrecision: 1),
                       "1\(groupingSeparator)000\(groupingSeparator)000\(groupingSeparator)000\(groupingSeparator)000")
    }

    func testBigDisplayAmountWithBigSubUnitToUnity() {
        let mintedToken = MintedToken(symbol: "", name: "", subUnitToUnit: 1000000000000000000)
        let balance = Balance(mintedToken: mintedToken, address: "", amount: 130000000000000000000)
        XCTAssertEqual(balance.displayAmount(), "130")
    }

    func testSmallestDisplayAmount() {
        let mintedToken = MintedToken(symbol: "", name: "", subUnitToUnit: 1000000000000000000)
        let balance = Balance(mintedToken: mintedToken, address: "", amount: 1)
        XCTAssertEqual(balance.displayAmount(), "0\(decimalSeparator)000000000000000001")
    }

    func testSmallNumberPrecision() {
        let mintedToken = MintedToken(symbol: "", name: "", subUnitToUnit: 1000000000000000000)
        let balance = Balance(mintedToken: mintedToken, address: "", amount: 1)
        XCTAssertEqual(balance.displayAmount(withPrecision: 2), "0")
    }

}
