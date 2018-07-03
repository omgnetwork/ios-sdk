//
//  AuthenticationLiveTest.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 6/11/2017.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

import OmiseGO
import XCTest

class AuthenticationLiveTest: LiveTestCase {
    func testInvalidAuthenticationToken() {
        let expectation = self.expectation(description: "Error token not found")
        let config = ClientConfiguration(baseURL: self.validBaseURL,
                                         apiKey: self.validAPIKey,
                                         authenticationToken: self.invalidAuthenticationToken)
        let client = HTTPClient(config: config)
        let request = User.getCurrent(using: client) { response in
            defer { expectation.fulfill() }
            switch response {
            case .success(data: _):
                XCTFail("Call shouldn't succeed with an invalid authentication token")
            case let .fail(error: error):
                switch error {
                case let .api(apiError: apiError) where apiError.isAuthorizationError():
                    XCTAssertEqual(apiError.code, .authenticationTokenNotFound)
                default:
                    XCTFail("Error should be an authorization error")
                }
            }
        }
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }

    func testInvalidAPIKey() {
        let expectation = self.expectation(description: "Invalid API key")
        let config = ClientConfiguration(baseURL: self.validBaseURL,
                                         apiKey: self.invalidAPIKey,
                                         authenticationToken: self.validAuthenticationToken)
        let client = HTTPClient(config: config)
        let request = User.getCurrent(using: client) { response in
            defer { expectation.fulfill() }
            switch response {
            case .success(data: _):
                XCTFail("Call shouldn't succeed with an invalid authentication token")
            case let .fail(error: error):
                switch error {
                case let .api(apiError: apiError) where apiError.isAuthorizationError():
                    XCTAssertEqual(apiError.code, .invalidAPIKey)
                default:
                    XCTFail("Error should be an authorization error")
                }
            }
        }
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
}
