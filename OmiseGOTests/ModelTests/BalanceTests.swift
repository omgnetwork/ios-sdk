//
//  BalanceTests.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 12/10/2560 BE.
//  Copyright © 2560 OmiseGO. All rights reserved.
//

import XCTest
@testable import OmiseGO

class BalanceTests: XCTestCase {

    let decimalSeparator = NSLocale.current.decimalSeparator ?? "."
    let groupingSeparator = NSLocale.current.groupingSeparator ?? ","

    func testStandardDisplayAmount() {
        let mintedToken = MintedToken(id: "", symbol: "", name: "", subUnitToUnit: 1000)
        let balance = Balance(mintedToken: mintedToken, amount: 13)
        XCTAssertEqual(balance.displayAmount(), "0\(decimalSeparator)013")
    }

    func testZeroDisplayAmount() {
        let mintedToken = MintedToken(id: "", symbol: "", name: "", subUnitToUnit: 1000)
        let balance = Balance(mintedToken: mintedToken, amount: 0)
        XCTAssertEqual(balance.displayAmount(), "0")
    }

    func testBigDisplayAmount() {
        let mintedToken = MintedToken(id: "", symbol: "", name: "", subUnitToUnit: 1000)
        let balance = Balance(mintedToken: mintedToken, amount: 999999999999999)
        XCTAssertEqual(balance.displayAmount(),
                       "999\(groupingSeparator)999\(groupingSeparator)999\(groupingSeparator)999\(decimalSeparator)999")
    }

    func testBigDisplayAmountPrecision() {
        let mintedToken = MintedToken(id: "", symbol: "", name: "", subUnitToUnit: 1000)
        let balance = Balance(mintedToken: mintedToken, amount: 999999999999999)
        XCTAssertEqual(balance.displayAmount(withPrecision: 1),
                       "1\(groupingSeparator)000\(groupingSeparator)000\(groupingSeparator)000\(groupingSeparator)000")
    }

    func testBigDisplayAmountWithBigSubUnitToUnity() {
        let mintedToken = MintedToken(id: "", symbol: "", name: "", subUnitToUnit: 1000000000000000000)
        let balance = Balance(mintedToken: mintedToken, amount: 130000000000000000000)
        XCTAssertEqual(balance.displayAmount(), "130")
    }

    func testSmallestDisplayAmount() {
        let mintedToken = MintedToken(id: "", symbol: "", name: "", subUnitToUnit: 1000000000000000000)
        let balance = Balance(mintedToken: mintedToken, amount: 1)
        XCTAssertEqual(balance.displayAmount(), "0\(decimalSeparator)000000000000000001")
    }

    func testSmallNumberPrecision() {
        let mintedToken = MintedToken(id: "", symbol: "", name: "", subUnitToUnit: 1000000000000000000)
        let balance = Balance(mintedToken: mintedToken, amount: 1)
        XCTAssertEqual(balance.displayAmount(withPrecision: 2), "0")
    }

    func testEquatable() {
        let mintedToken1 = MintedToken(id: "OMG:123", symbol: "", name: "", subUnitToUnit: 1)
        let mintedToken2 = MintedToken(id: "BTC:123", symbol: "", name: "", subUnitToUnit: 1)
        let balance1 = Balance(mintedToken: mintedToken1, amount: 1)
        let balance2 = Balance(mintedToken: mintedToken1, amount: 1)
        let balance3 = Balance(mintedToken: mintedToken1, amount: 10)
        let balance4 = Balance(mintedToken: mintedToken2, amount: 10)
        XCTAssertEqual(balance1, balance2)
        XCTAssertNotEqual(balance1, balance3)
        XCTAssertNotEqual(balance1, balance4)
        XCTAssertNotEqual(balance3, balance4)
    }

    func testHashable() {
        let mintedToken1 = MintedToken(id: "OMG", symbol: "", name: "", subUnitToUnit: 1)
        let mintedToken2 = MintedToken(id: "BTC", symbol: "", name: "", subUnitToUnit: 1)
        let balance1 = Balance(mintedToken: mintedToken1, amount: 1)
        let balance2 = Balance(mintedToken: mintedToken1, amount: 1)
        let balance3 = Balance(mintedToken: mintedToken1, amount: 10)
        let balance4 = Balance(mintedToken: mintedToken2, amount: 10)
        let set: Set<Balance> = [balance1, balance2, balance3, balance4]
        XCTAssertEqual(balance1.hashValue, mintedToken1.hashValue ^ 1.0.hashValue)
        XCTAssertEqual(set.count, 3)
    }

}
