//
//  HTTPClientTests.swift
//  Tests
//
//  Created by Mederic Petit on 11/10/2017.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

@testable import OmiseGO
import XCTest

class HTTPClientTests: XCTestCase {
    func testInvalidURL() {
        let expectation = self.expectation(description: "Invalid url")
        let config = TestConfiguration(baseURL: "invalid url @")
        let client = HTTPClient(config: config)
        let dummyEndpoint = TestAPIEndpoint()
        let request: Request<TestObject>? = client.request(toEndpoint: dummyEndpoint) { result in
            defer {
                expectation.fulfill()
            }
            switch result {
            case .success(data: _):
                XCTFail("Request should not be executed if base url is not correct")
            case let .fail(error):
                switch error {
                case .configuration(message: _): break
                default: XCTFail("Error should be a configuration error")
                }
            }
        }
        XCTAssertNil(request, "Request should be nil")
        waitForExpectations(timeout: 15.0, handler: nil)
    }
}
