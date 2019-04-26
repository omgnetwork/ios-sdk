//
//  HTTPClientTests.swift
//  Tests
//
//  Created by Mederic Petit on 11/10/2017.
//  Copyright © 2017-2019 Omise Go Pte. Ltd. All rights reserved.
//

@testable import OmiseGO
import XCTest

class HTTPClientTests: XCTestCase {
    func testIsAuthenticatedIsTrueWhenAuthenticated() {
        let config = TestConfiguration(baseURL: "http://localhost:4000", credentials: TestCredential(authenticated: true))
        let client = HTTPAPI(config: config)
        XCTAssertTrue(client.isAuthenticated)
    }

    func testIsAuthenticatedIsFalseWhenNotAuthenticated() {
        let config = TestConfiguration(baseURL: "http://localhost:4000", credentials: TestCredential(authenticated: false))
        let client = HTTPAPI(config: config)
        XCTAssertFalse(client.isAuthenticated)
    }

    func testInvalidURL() {
        let expectation = self.expectation(description: "Invalid url")
        let config = TestConfiguration(baseURL: "invalid url @")
        let client = HTTPAPI(config: config)
        let dummyEndpoint = TestAPIEndpoint()
        let request: Request<TestObject>? = client.request(toEndpoint: dummyEndpoint) { result in
            defer {
                expectation.fulfill()
            }
            switch result {
            case .success(data: _):
                XCTFail("Request should not be executed if base url is not correct")
            case let .failure(error):
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
