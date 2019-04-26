//
//  ResponseTest.swift
//  Tests
//
//  Created by Mederic Petit on 10/10/2017.
//  Copyright © 2017-2019 Omise Go Pte. Ltd. All rights reserved.
//

@testable import OmiseGO
import XCTest

class ResponseFixtureTest: FixtureTestCase {
    func testParseSuccessResponse() {
        let expectation = self.expectation(description: "Parse success response")
        let endpoint = TestAPIEndpoint(path: "dummy.success")
        let request: Request<TestObject>? = self.testClient.request(toEndpoint: endpoint) { result in
            defer { expectation.fulfill() }
            switch result {
            case let .success(object):
                XCTAssertEqual(object.object, "success_test_object")
            case let .failure(error):
                XCTFail("\(error)")
            }
        }
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }

    func testParseErrorResponse() {
        let expectation = self.expectation(description: "Parse error response")
        let endpoint = TestAPIEndpoint(path: "dummy.failure")
        let request: Request<TestObject>? = self.testClient.request(toEndpoint: endpoint) { result in
            defer { expectation.fulfill() }
            switch result {
            case .success(data: _):
                XCTFail("Should not succeed")
            case let .failure(error):
                XCTAssertEqual(error.description, "error_message")
            }
        }
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
}
