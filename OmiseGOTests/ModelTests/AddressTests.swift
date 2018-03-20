//
//  AddressTests.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 20/11/2017.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

import XCTest
import OmiseGO

class AddressTests: XCTestCase {

    func testEquatable() {
        let address1 = StubGenerator.address(address: "123")
        let address2 = StubGenerator.address(address: "123")
        let address3 = StubGenerator.address(address: "321")
        XCTAssertEqual(address1, address2)
        XCTAssertNotEqual(address1, address3)
    }

    func testHashable() {
        let address1 = StubGenerator.address(address: "123")
        let address2 = StubGenerator.address(address: "123")
        let set: Set<Address> = [address1, address2]
        XCTAssertEqual(address1.hashValue, "123".hashValue)
        XCTAssertEqual(set.count, 1)
    }

}
