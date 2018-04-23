//
//  AccountTest.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 20/4/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import XCTest
import OmiseGO

class AccountTest: XCTestCase {

    func testEquatable() {
        let account1 = StubGenerator.account(id: "123")
        let account2 = StubGenerator.account(id: "123")
        let account3 = StubGenerator.account(id: "321")
        XCTAssertEqual(account1, account2)
        XCTAssertNotEqual(account1, account3)
    }

    func testHashable() {
        let account1 = StubGenerator.account(id: "123")
        let account2 = StubGenerator.account(id: "123")
        let set: Set<Account> = [account1, account2]
        XCTAssertEqual(account1.hashValue, "123".hashValue)
        XCTAssertEqual(set.count, 1)
    }

}
