//
//  ResponseTest.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 10/10/2017.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

import XCTest
@testable import OmiseGO

class ResponseFixtureTest: FixtureTestCase {

    func testParseSuccessResponse() {
        let expectation = self.expectation(description: "Parse success response")
        let endpoint = APIEndpoint.custom(path: "dummy.success", task: .requestPlain)
        let request: OMGRequest<DummyTestObject>? = self.testCustomClient.request(toEndpoint: endpoint) { (result) in
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

    func testParseErrorResponse() {
        let expectation = self.expectation(description: "Parse error response")
        let endpoint = APIEndpoint.custom(path: "dummy.failure", task: .requestPlain)
        let request: OMGRequest<DummyTestObject>? = self.testCustomClient.request(toEndpoint: endpoint) { (result) in
            defer { expectation.fulfill() }
            switch result {
            case .success(data: _):
                XCTFail("Should not succeed")
            case .fail(let error):
                XCTAssertEqual(error.description, "error_message")
            }
        }
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
}
