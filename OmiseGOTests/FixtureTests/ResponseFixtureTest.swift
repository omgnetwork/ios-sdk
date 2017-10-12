//
//  ResponseTest.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 10/10/2560 BE.
//  Copyright © 2560 OmiseGO. All rights reserved.
//
// swiftlint:disable empty_enum_arguments

import XCTest
@testable import OmiseGO

class ResponseTest: FixtureTestCase {

    func testValidResponse() {
        let expectation = self.expectation(description: "Success response")

        let endpoint = APIEndpoint<DummyTestObject>(action: "dummy.success")
        let request = self.testClient.request(toEndpoint: endpoint) { (result) in
            defer { expectation.fulfill() }
            switch result {
            case let .success(object):
                XCTAssertEqual(object.object, "success_test_object")
            case .fail(let error):
                XCTFail("\(error)")
            }
        }
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }

    func testErrorResponse() {
        let expectation = self.expectation(description: "Error response")
        let endpoint = APIEndpoint<DummyTestObject>(action: "dummy.failure")
        let request = self.testClient.request(toEndpoint: endpoint) { (result) in
            defer { expectation.fulfill() }
            switch result {
            case .success(_):
                XCTFail("Should not succeed")
            case .fail(let error):
                XCTAssertEqual(error.description, "(error_code) error_message")
            }
        }
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
}
