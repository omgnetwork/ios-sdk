//
//  UserTests.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 20/11/2560 BE.
//  Copyright © 2560 OmiseGO. All rights reserved.
//

import XCTest
@testable import OmiseGO

class UserTests: XCTestCase {

    func testEquatable() {
        let user1 = User(id: "123", providerUserId: "", username: "", metadata: [:])
        let user2 = User(id: "123", providerUserId: "", username: "", metadata: [:])
        let user3 = User(id: "321", providerUserId: "", username: "", metadata: [:])
        XCTAssertEqual(user1, user2)
        XCTAssertNotEqual(user1, user3)
    }

    func testHashable() {
        let user1 = User(id: "123", providerUserId: "", username: "", metadata: [:])
        let user2 = User(id: "123", providerUserId: "", username: "", metadata: [:])
        let set: Set<User> = [user1, user2]
        XCTAssertEqual(user1.hashValue, "123".hashValue)
        XCTAssertEqual(set.count, 1)
    }

}
