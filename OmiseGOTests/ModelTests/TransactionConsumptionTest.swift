//
//  TransactionConsumptionTest.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 13/2/2018.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

import XCTest
import OmiseGO

class TransactionConsumptionTest: XCTestCase {

    func testEquatable() {
        let transactionConsumption1 = StubGenerator.transactionConsumption(id: "1")
        let transactionConsumption2 = StubGenerator.transactionConsumption(id: "1")
        let transactionConsumption3 = StubGenerator.transactionConsumption(id: "2")
        XCTAssertEqual(transactionConsumption1, transactionConsumption2)
        XCTAssertNotEqual(transactionConsumption1, transactionConsumption3)
    }

    func testHashable() {
        let transactionConsumption1 = StubGenerator.transactionConsumption(id: "1")
        let transactionConsumption2 = StubGenerator.transactionConsumption(id: "1")
        let set: Set<TransactionConsumption> = [transactionConsumption1, transactionConsumption2]
        XCTAssertEqual(transactionConsumption1.hashValue, "1".hashValue)
        XCTAssertEqual(set.count, 1)
    }

}
