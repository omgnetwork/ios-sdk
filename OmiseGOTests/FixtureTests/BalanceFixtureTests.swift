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

    func testStandardDisplayAmount() {
        let mintedToken = MintedToken(symbol: "", name: "", subUnitToUnit: 1000)
        let balance = Balance(mintedToken: mintedToken, amount: 13)
        XCTAssertEqual(balance.displayAmount(), "0\(decimalSeparator)013")
    }

    func testZeroDisplayAmount() {
        let mintedToken = MintedToken(symbol: "", name: "", subUnitToUnit: 1000)
        let balance = Balance(mintedToken: mintedToken, amount: 0)
        XCTAssertEqual(balance.displayAmount(), "0")
    }

    func testBigDisplayAmount() {
        let mintedToken = MintedToken(symbol: "", name: "", subUnitToUnit: 1000)
        let balance = Balance(mintedToken: mintedToken, amount: 999999999999999)
        XCTAssertEqual(balance.displayAmount(),
                       "999\(groupingSeparator)999\(groupingSeparator)999\(groupingSeparator)999\(decimalSeparator)999")
    }

    func testBigDisplayAmountPrecision() {
        let mintedToken = MintedToken(symbol: "", name: "", subUnitToUnit: 1000)
        let balance = Balance(mintedToken: mintedToken, amount: 999999999999999)
        XCTAssertEqual(balance.displayAmount(withPrecision: 1),
                       "1\(groupingSeparator)000\(groupingSeparator)000\(groupingSeparator)000\(groupingSeparator)000")
    }

    func testBigDisplayAmountWithBigSubUnitToUnity() {
        let mintedToken = MintedToken(symbol: "", name: "", subUnitToUnit: 1000000000000000000)
        let balance = Balance(mintedToken: mintedToken, amount: 130000000000000000000)
        XCTAssertEqual(balance.displayAmount(), "130")
    }

    func testSmallestDisplayAmount() {
        let mintedToken = MintedToken(symbol: "", name: "", subUnitToUnit: 1000000000000000000)
        let balance = Balance(mintedToken: mintedToken, amount: 1)
        XCTAssertEqual(balance.displayAmount(), "0\(decimalSeparator)000000000000000001")
    }

    func testSmallNumberPrecision() {
        let mintedToken = MintedToken(symbol: "", name: "", subUnitToUnit: 1000000000000000000)
        let balance = Balance(mintedToken: mintedToken, amount: 1)
        XCTAssertEqual(balance.displayAmount(withPrecision: 2), "0")
    }

}
