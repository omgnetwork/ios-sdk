//
//  ExchangePairTest.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 29/6/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import OmiseGO
import XCTest

class ExchangePairTest: XCTestCase {
    func testEquatable() {
        let pair1 = StubGenerator.exchangePair(id: "123")
        let pair2 = StubGenerator.exchangePair(id: "123")
        let pair3 = StubGenerator.exchangePair(id: "321")
        XCTAssertEqual(pair1, pair2)
        XCTAssertNotEqual(pair1, pair3)
    }

    func testHashable() {
        let pair1 = StubGenerator.exchangePair(id: "123")
        let pair2 = StubGenerator.exchangePair(id: "123")
        let set: Set<ExchangePair> = [pair1, pair2]
        XCTAssertEqual(pair1.hashValue, "123".hashValue)
        XCTAssertEqual(set.count, 1)
    }
}
