//
//  WalletTests.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 20/11/2017.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

import OmiseGO
import XCTest

class WalletTests: XCTestCase {
    func testEquatable() {
        let address1 = StubGenerator.wallet(address: "123")
        let address2 = StubGenerator.wallet(address: "123")
        let address3 = StubGenerator.wallet(address: "321")
        XCTAssertEqual(address1, address2)
        XCTAssertNotEqual(address1, address3)
    }

    func testHashable() {
        let address1 = StubGenerator.wallet(address: "123")
        let address2 = StubGenerator.wallet(address: "123")
        let set: Set<Wallet> = [address1, address2]
        XCTAssertEqual(address1.hashValue, "123".hashValue)
        XCTAssertEqual(set.count, 1)
    }
}
