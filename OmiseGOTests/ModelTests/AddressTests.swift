//
//  AddressTests.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 20/11/2560 BE.
//  Copyright © 2560 OmiseGO. All rights reserved.
//

import XCTest
@testable import OmiseGO

class AddressTests: XCTestCase {

    func testEquatable() {
        let address1 = Address(address: "123", balances: [])
        let address2 = Address(address: "123", balances: [])
        let address3 = Address(address: "321", balances: [])
        XCTAssertEqual(address1, address2)
        XCTAssertNotEqual(address1, address3)
    }

    func testHashable() {
        let address1 = Address(address: "123", balances: [])
        let address2 = Address(address: "123", balances: [])
        let set: Set<Address> = [address1, address2]
        XCTAssertEqual(address1.hashValue, "123".hashValue)
        XCTAssertEqual(set.count, 1)
    }

}
