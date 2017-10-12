//
//  ClientTests.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 11/10/2560 BE.
//  Copyright © 2560 OmiseGO. All rights reserved.
//
// swiftlint:disable empty_enum_arguments

import XCTest
@testable import OmiseGO

class ClientTests: XCTestCase {

    func testInvalidURL() {
        let expectation = self.expectation(description: "Invalid url")
        let url: String = "invalid url @"
        let apiKey: String = "dummy_apikey"
        let authenticationToken: String = "dummy_authenticationtoken"
        let config = APIConfiguration(baseURL: url, apiKey: apiKey, authenticationToken: authenticationToken)
        let client = APIClient(config: config)
        let dummyEndpoint = APIEndpoint<DummyTestObject>(action: "dummy_action")
        let request = client.request(toEndpoint: dummyEndpoint) { result in
            defer {
                expectation.fulfill()
            }
            switch result {
            case .success(_):
                XCTFail("Request should not be executed if base url is not correct")
            case .fail(let error):
                switch error {
                case .configuration(_):
                    XCTAssertTrue(true)
                default:
                    XCTFail("Error should be a configuration error")
                }
            }
        }
        XCTAssertNil(request, "Request should be nil")
        waitForExpectations(timeout: 15.0, handler: nil)
    }

    func testMissingClientConfiguration() {
        let expectation = self.expectation(description: "Missing configuration")
        let client = APIClient.shared
        let dummyEndpoint = APIEndpoint<DummyTestObject>(action: "dummy_action")
        let request = client.request(toEndpoint: dummyEndpoint) { result in
            defer {
                expectation.fulfill()
            }
            switch result {
            case .success(_):
                XCTFail("Request should not be executed if config was not provided to the client")
            case .fail(let error):
                switch error {
                case .configuration(_):
                    XCTAssertTrue(true)
                default:
                    XCTFail("Error should be a configuration error")
                }
            }
        }
        XCTAssertNil(request, "Request should be nil")
        waitForExpectations(timeout: 15.0, handler: nil)
    }
}
