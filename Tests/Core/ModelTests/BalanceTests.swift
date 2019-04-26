//
//  BalanceTests.swift
//  Tests
//
//  Created by Mederic Petit on 12/10/2017.
//  Copyright © 2017-2019 Omise Go Pte. Ltd. All rights reserved.
//

import BigInt
import OmiseGO
import XCTest

class BalanceTests: XCTestCase {
    let decimalSeparator = NSLocale.current.decimalSeparator ?? "."
    let groupingSeparator = NSLocale.current.groupingSeparator ?? ","

    func testStandardDisplayAmount() {
        let token = StubGenerator.token(subUnitToUnit: 1000)
        let balance = StubGenerator.balance(token: token, amount: 13)
        XCTAssertEqual(balance.displayAmount(), "0\(decimalSeparator)013")
    }

    func testZeroDisplayAmount() {
        let token = StubGenerator.token(subUnitToUnit: 1000)
        let balance = StubGenerator.balance(token: token, amount: 0)
        XCTAssertEqual(balance.displayAmount(), "0")
    }

    func testBigDisplayAmount() {
        let token = StubGenerator.token(subUnitToUnit: 1000)
        let balance = StubGenerator.balance(token: token, amount: 999_999_999_999_999)
        XCTAssertEqual(balance.displayAmount(),
                       "999\(groupingSeparator)999\(groupingSeparator)999\(groupingSeparator)999\(decimalSeparator)999")
    }

    func testBigDisplayAmountPrecision() {
        let token = StubGenerator.token(subUnitToUnit: 1000)
        let balance = StubGenerator.balance(token: token, amount: 999_999_999_999_999)
        XCTAssertEqual(balance.displayAmount(withPrecision: 1),
                       "999\(groupingSeparator)999\(groupingSeparator)999\(groupingSeparator)999\(decimalSeparator)9")
    }

    func testBigDisplayAmountWithBigSubUnitToUnity() {
        let token = StubGenerator.token(subUnitToUnit: 1_000_000_000_000_000_000)
        let balance = StubGenerator.balance(token: token, amount: BigInt("130000000000000000000"))
        XCTAssertEqual(balance.displayAmount(), "130")
    }

    func testSmallestDisplayAmount() {
        let token = StubGenerator.token(subUnitToUnit: 1_000_000_000_000_000_000)
        let balance = StubGenerator.balance(token: token, amount: 1)
        XCTAssertEqual(balance.displayAmount(), "0\(decimalSeparator)000000000000000001")
    }

    func testSmallNumberPrecision() {
        let token = StubGenerator.token(subUnitToUnit: 1_000_000_000_000_000_000)
        let balance = StubGenerator.balance(token: token, amount: 1)
        XCTAssertEqual(balance.displayAmount(withPrecision: 2), "0")
    }

    func testEquatable() {
        let token1 = StubGenerator.token(id: "OMG:123", subUnitToUnit: 1)
        let token2 = StubGenerator.token(id: "BTC:123", subUnitToUnit: 1)
        let balance1 = StubGenerator.balance(token: token1)
        let balance2 = StubGenerator.balance(token: token1)
        let balance3 = StubGenerator.balance(token: token2)
        XCTAssertEqual(balance1, balance2)
        XCTAssertNotEqual(balance1, balance3)
    }

    func testHashable() {
        let token1 = StubGenerator.token(id: "OMG", subUnitToUnit: 1)
        let token2 = StubGenerator.token(id: "BTC", subUnitToUnit: 1)
        let balance1 = StubGenerator.balance(token: token1)
        let balance2 = StubGenerator.balance(token: token1)
        let balance3 = StubGenerator.balance(token: token2)
        let set: Set<Balance> = [balance1, balance2, balance3]
        XCTAssertEqual(balance1.hashValue, "OMG".hashValue)
        XCTAssertEqual(set.count, 2)
    }
}
