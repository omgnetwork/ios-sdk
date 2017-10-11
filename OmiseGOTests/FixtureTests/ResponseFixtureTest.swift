//
//  ResponseTest.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 10/10/2560 BE.
//  Copyright © 2560 OmiseGO. All rights reserved.
//

import XCTest
@testable import OmiseGO

class ResponseTest: FixtureTestCase {

    func testValidResponse() {
        let expectation = self.expectation(description: "Success response")

        guard let endpoint = APIEndpoint<SuccessTestObject>(baseURL: self.testClient.config.baseURL,
                                                                 action: "dummy.success") else {
            return
        }
        let request = self.testClient.requestToEndpoint(endpoint) { (result) in
            defer { expectation.fulfill() }
            switch result {
            case let .success(object):
                XCTAssertEqual(object.object, "success_test_object")
            case let .fail(error):
                XCTFail("\(error)")
            }
        }
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }

    func testErrorResponse() {
        let expectation = self.expectation(description: "Error response")
        guard let endpoint = APIEndpoint<SuccessTestObject>(baseURL: self.testClient.config.baseURL,
                                                                 action: "dummy.failure") else {
            return
        }
        let request = self.testClient.requestToEndpoint(endpoint) { (result) in
            defer { expectation.fulfill() }
            switch result {
            case .success(_):
                XCTFail("Should not succeed")
            case let .fail(error):
                XCTAssertEqual(error.description, "(error_code) error_message")
            }
        }
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }

}
