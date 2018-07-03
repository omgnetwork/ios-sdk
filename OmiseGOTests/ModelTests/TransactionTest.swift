//
//  TransactionTest.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 23/2/18.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

import OmiseGO
import XCTest

class TransactionTest: XCTestCase {
    func testEquatable() {
        let transaction1 = StubGenerator.transaction(id: "1")
        let transaction2 = StubGenerator.transaction(id: "1")
        let transaction3 = StubGenerator.transaction(id: "2")
        XCTAssertEqual(transaction1, transaction2)
        XCTAssertNotEqual(transaction1, transaction3)
    }

    func testHashable() {
        let transaction1 = StubGenerator.transaction(id: "1")
        let transaction2 = StubGenerator.transaction(id: "1")
        let set: Set<Transaction> = [transaction1, transaction2]
        XCTAssertEqual(transaction1.hashValue, "1".hashValue)
        XCTAssertEqual(set.count, 1)
    }
}
