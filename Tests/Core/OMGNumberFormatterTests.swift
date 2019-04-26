//
//  OMGNumberFormatterTests.swift
//  Tests
//
//  Created by Mederic Petit on 18/6/18.
//  Copyright © 2017-2019 Omise Go Pte. Ltd. All rights reserved.
//

import BigInt
@testable import OmiseGO
import XCTest

class OMGNumberFormatterTests: XCTestCase {
    let locale = NSLocale.current

    func testStringToBigIntWithSubunitToUnit() {
        let sut = OMGNumberFormatter(locale: self.locale, precision: 1)
        let result = sut.number(from: "10", subunitToUnit: 1_000_000_000_000_000_000)
        XCTAssertEqual(result, BigInt("10000000000000000000"))
    }

    func testStringToBigIntWithDecimal() {
        let sut = OMGNumberFormatter(locale: self.locale, precision: 1)
        let result = sut.number(from: "10", decimals: 18)
        XCTAssertEqual(result, BigInt("10000000000000000000"))
    }

    func testStringToBigIntWithDecimalAndPrecision() {
        let sut = OMGNumberFormatter(locale: self.locale, precision: 10000)
        let result = sut.number(from: "10", decimals: 18)
        XCTAssertEqual(result, BigInt("10000000000000000000"))
    }

    func testStringFromBigIntWithSubunitToUnit() {
        let sut = OMGNumberFormatter(locale: self.locale, precision: 1)
        let result = sut.string(from: BigInt("10000000000000000000"), subunitToUnit: 1_000_000_000_000_000_000)
        XCTAssertEqual(result, "10")
    }

    func testStringFromBigIntWithDecimal() {
        let sut = OMGNumberFormatter(locale: self.locale, precision: 1)
        let result = sut.string(from: BigInt("10000000000000000000"), decimals: 18)
        XCTAssertEqual(result, "10")
    }

    func testStringFromBigIntWithDecimalAndPrecision() {
        let sut = OMGNumberFormatter(locale: self.locale, precision: 2)
        let result = sut.string(from: BigInt("1"), decimals: 2)
        XCTAssertEqual(result, "0\(self.locale.decimalSeparator ?? ".")01")
    }
}
