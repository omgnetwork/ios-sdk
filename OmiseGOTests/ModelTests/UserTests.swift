//
//  UserTests.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 20/11/2017.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

import OmiseGO
import XCTest

class UserTests: XCTestCase {
    func testEquatable() {
        let user1 = StubGenerator.user(id: "123")
        let user2 = StubGenerator.user(id: "123")
        let user3 = StubGenerator.user(id: "321")
        XCTAssertEqual(user1, user2)
        XCTAssertNotEqual(user1, user3)
    }

    func testHashable() {
        let user1 = StubGenerator.user(id: "123")
        let user2 = StubGenerator.user(id: "123")
        let set: Set<User> = [user1, user2]
        XCTAssertEqual(user1.hashValue, "123".hashValue)
        XCTAssertEqual(set.count, 1)
    }
}
