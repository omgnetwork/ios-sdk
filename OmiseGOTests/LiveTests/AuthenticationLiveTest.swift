//
//  AuthenticationLiveTest.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 6/11/2017 BE.
//  Copyright © 2017 OmiseGO. All rights reserved.
//

import XCTest
@testable import OmiseGO

class AuthenticationLiveTest: LiveTestCase {

    func testInvalidAuthenticationToken() {
        let expectation = self.expectation(description: "Error token not found")
        let config = OMGConfiguration(baseURL: self.validBaseURL,
                                      apiKey: self.validAPIKey,
                                      authenticationToken: self.invalidAuthenticationToken)
        let client = OMGClient(config: config)
        let request = User.getCurrent(using: client) { (response) in
            defer { expectation.fulfill() }
            switch response {
            case .success(data: _):
                XCTFail("Call shouldn't succeed with an invalid authentication token")
            case .fail(error: let error):
                switch error {
                case .api(apiError: let apiError) where apiError.isAuthorizationError():
                    switch apiError.code {
                    case .accessTokenNotFound: XCTAssertTrue(true)
                    default: XCTFail("Error should be token not found")
                    }
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
        let config = OMGConfiguration(baseURL: self.validBaseURL,
                                      apiKey: self.invalidAPIKey,
                                      authenticationToken: self.validAuthenticationToken)
        let client = OMGClient(config: config)
        let request = User.getCurrent(using: client) { (response) in
            defer { expectation.fulfill() }
            switch response {
            case .success(data: _):
                XCTFail("Call shouldn't succeed with an invalid authentication token")
            case .fail(error: let error):
                switch error {
                case .api(apiError: let apiError) where apiError.isAuthorizationError():
                    switch apiError.code {
                    case .invalidAPIKey: XCTAssertTrue(true)
                    default: XCTFail("Error should be invalid api key")
                    }
                default:
                    XCTFail("Error should be an authorization error")
                }
            }
        }
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }

}
