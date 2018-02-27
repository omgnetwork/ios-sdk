//
//  AddressLiveTests.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 10/11/2017 BE.
//  Copyright © 2017 OmiseGO. All rights reserved.
//

import XCTest
import OmiseGO

class AddressLiveTests: LiveTestCase {

    func testGetAll() {
        let expectation = self.expectation(description: "Addresses result")
        let request = Address.getAll(using: self.testClient) { (result) in
            defer { expectation.fulfill() }
            switch result {
            case .success(data: let addresses):
                XCTAssert(!addresses.isEmpty)
            case .fail(error: let error):
                XCTFail("\(error)")
            }
        }
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }

    func testGetMain() {
        let expectation = self.expectation(description: "Get the main address")
        let request = Address.getMain(using: self.testClient) { (result) in
            defer { expectation.fulfill() }
            switch result {
            case .success(data: _):
                XCTAssertTrue(true)
            case .fail(error: let error):
                XCTFail("\(error)")
            }
        }
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }

}
