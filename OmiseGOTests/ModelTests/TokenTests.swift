//
//  TokenTests.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 20/11/2017.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

import XCTest
import OmiseGO

class TokenTests: XCTestCase {

    func testEquatable() {
        let token1 = StubGenerator.token(id: "OMG:123")
        let token2 = StubGenerator.token(id: "OMG:123")
        let token3 = StubGenerator.token(id: "BTC:123")
        XCTAssertEqual(token1, token2)
        XCTAssertNotEqual(token1, token3)
    }

    func testHashable() {
        let token1 = StubGenerator.token(id: "OMG:123")
        let token2 = StubGenerator.token(id: "OMG:123")
        let set: Set<Token> = [token1, token2]
        XCTAssertEqual(token1.hashValue, "OMG:123".hashValue)
        XCTAssertEqual(set.count, 1)
    }

}
