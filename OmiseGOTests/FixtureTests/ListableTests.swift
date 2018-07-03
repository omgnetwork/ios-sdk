//
//  ListableTests.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 7/3/18.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

import OmiseGO
import XCTest

class ListableTests: FixtureTestCase {
    func testListableFailure() {
        let expectation = self.expectation(description: "Fails to load the response for this dummy object")
        ListableDummy.list(using: self.testClient) { response in
            defer { expectation.fulfill() }
            switch response {
            case .success(data: _): XCTFail("Shouldn't succeed")
            case let .fail(error: error):
                XCTAssertEqual(error.message, "error_message")
            }
        }
        waitForExpectations(timeout: 15.0, handler: nil)
    }

    func testPaginatedListableFailure() {
        let expectation = self.expectation(description: "Fails to load the response for this paginated dummy object")
        PaginatedListableDummy.list(using: self.testClient) { response in
            defer { expectation.fulfill() }
            switch response {
            case .success(data: _): XCTFail("Shouldn't succeed")
            case let .fail(error: error):
                XCTAssertEqual(error.message, "error_message")
            }
        }
        waitForExpectations(timeout: 15.0, handler: nil)
    }
}
