//
//  AuthenticationTokenTests.swift
//  Tests
//
//  Created by Mederic Petit on 15/8/18.
//  Copyright © 2017-2019 Omise Go Pte. Ltd. All rights reserved.
//

import OmiseGO
import XCTest

class AuthenticationTokenTests: XCTestCase {
    func testEquatable() {
        let token1 = StubGenerator.authenticationToken(token: "123")
        let token2 = StubGenerator.authenticationToken(token: "123")
        let token3 = StubGenerator.authenticationToken(token: "789")
        XCTAssertEqual(token1, token2)
        XCTAssertNotEqual(token1, token3)
    }

    func testHashable() {
        let token1 = StubGenerator.authenticationToken(token: "123")
        let token2 = StubGenerator.authenticationToken(token: "123")
        let set: Set<AuthenticationToken> = [token1, token2]
        XCTAssertEqual(token1.hashValue, "123".hashValue)
        XCTAssertEqual(set.count, 1)
    }
}
