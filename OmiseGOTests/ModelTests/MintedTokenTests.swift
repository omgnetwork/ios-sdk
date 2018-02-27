//
//  MintedTokenTests.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 20/11/2017 BE.
//  Copyright © 2017 OmiseGO. All rights reserved.
//

import XCTest
@testable import OmiseGO

class MintedTokenTests: XCTestCase {

    func testEquatable() {
        let mintedToken1 = StubGenerator.mintedToken(id: "OMG:123")
        let mintedToken2 = StubGenerator.mintedToken(id: "OMG:123")
        let mintedToken3 = StubGenerator.mintedToken(id: "BTC:123")
        XCTAssertEqual(mintedToken1, mintedToken2)
        XCTAssertNotEqual(mintedToken1, mintedToken3)
    }

    func testHashable() {
        let mintedToken1 = StubGenerator.mintedToken(id: "OMG:123")
        let mintedToken2 = StubGenerator.mintedToken(id: "OMG:123")
        let set: Set<MintedToken> = [mintedToken1, mintedToken2]
        XCTAssertEqual(mintedToken1.hashValue, "OMG:123".hashValue)
        XCTAssertEqual(set.count, 1)
    }

}
