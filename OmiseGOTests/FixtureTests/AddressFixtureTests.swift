//
//  AddressFixtureTests.swift
//  OmiseGOTests
//
//  Created by Thibault Denizet on 11/10/2017 BE.
//  Copyright © 2017 OmiseGO. All rights reserved.
//

import XCTest
import OmiseGO

class AddressFixtureTests: FixtureTestCase {

    func testGetAll() {
        let expectation = self.expectation(description: "Get all addresses for current user")
        let request = Address.getAll(using: self.testCustomClient) { (result) in
            defer { expectation.fulfill() }
            switch result {
            case .success(data: let addresses):
                XCTAssertEqual(addresses.count, 1)
                let address = addresses.first!
                XCTAssertEqual(address.address, "2c2e0f2e-fa0f-4abe-8516-9e92cf003486")

                XCTAssertEqual(address.balances.count, 2)
                let balance1 = address.balances[0]
                let balance2 = address.balances[1]

                XCTAssertEqual(balance1.amount, 103100)
                XCTAssertEqual(balance1.mintedToken.id, "OMG:123")
                XCTAssertEqual(balance1.mintedToken.symbol, "OMG")
                XCTAssertEqual(balance1.mintedToken.subUnitToUnit, 10000)

                XCTAssertEqual(balance2.amount, 133700)
                XCTAssertEqual(balance2.mintedToken.id, "KNC:123")
                XCTAssertEqual(balance2.mintedToken.symbol, "KNC")
                XCTAssertEqual(balance2.mintedToken.subUnitToUnit, 10000)
            case .fail(error: let error):
                XCTFail("\(error)")
            }
        }
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }

    func testGetMain() {
        let expectation = self.expectation(description: "Get the main address of the current user")
        let request = Address.getMain(using: self.testCustomClient) { (result) in
            defer { expectation.fulfill() }
            switch result {
            case .success(data: let address):
                XCTAssertEqual(address.address, "2c2e0f2e-fa0f-4abe-8516-9e92cf003486")

                XCTAssertEqual(address.balances.count, 2)
                let balance1 = address.balances[0]
                let balance2 = address.balances[1]

                XCTAssertEqual(balance1.amount, 103100)
                XCTAssertEqual(balance1.mintedToken.id, "OMG:123")
                XCTAssertEqual(balance1.mintedToken.symbol, "OMG")
                XCTAssertEqual(balance1.mintedToken.subUnitToUnit, 10000)

                XCTAssertEqual(balance2.amount, 133700)
                XCTAssertEqual(balance2.mintedToken.id, "KNC:123")
                XCTAssertEqual(balance2.mintedToken.symbol, "KNC")
                XCTAssertEqual(balance2.mintedToken.subUnitToUnit, 10000)
            case .fail(error: let error):
                XCTFail("\(error)")
            }
        }
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
}
