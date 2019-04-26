//
//  AuthenticationLiveTests.swift
//  Tests
//
//  Created by Mederic Petit on 6/11/2017.
//  Copyright © 2017-2019 Omise Go Pte. Ltd. All rights reserved.
//

import OmiseGO
import XCTest

class AuthenticationLiveTests: LiveClientTestCase {
    func testInvalidAuthenticationToken() {
        let expectation = self.expectation(description: "Error token not found")
        let credential = ClientCredential(apiKey: self.validAPIKey, authenticationToken: self.invalidAuthenticationToken)
        let config = ClientConfiguration(baseURL: self.validBaseURL,
                                         credentials: credential)
        let client = HTTPClientAPI(config: config)
        let request = User.getCurrent(using: client) { response in
            defer { expectation.fulfill() }
            switch response {
            case .success(data: _):
                XCTFail("Call shouldn't succeed with an invalid authentication token")
            case let .failure(error):
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
        let credential = ClientCredential(apiKey: self.invalidAPIKey, authenticationToken: self.validAuthenticationToken)
        let config = ClientConfiguration(baseURL: self.validBaseURL,
                                         credentials: credential)
        let client = HTTPClientAPI(config: config)
        let request = User.getCurrent(using: client) { response in
            defer { expectation.fulfill() }
            switch response {
            case .success(data: _):
                XCTFail("Call shouldn't succeed with an invalid authentication token")
            case let .failure(error):
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
