//
//  ClientTests.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 11/10/2017 BE.
//  Copyright © 2017 OmiseGO. All rights reserved.
//

import XCTest
@testable import OmiseGO

class ClientTests: XCTestCase {

    func testInvalidURL() {
        let expectation = self.expectation(description: "Invalid url")
        let url: String = "invalid url @"
        let apiKey: String = "dummy_apikey"
        let authenticationToken: String = "dummy_authenticationtoken"
        let config = OMGConfiguration(baseURL: url, apiKey: apiKey, authenticationToken: authenticationToken)
        let client = OMGClient(config: config)
        let dummyEndpoint = APIEndpoint.custom(path: "dummy_action", task: .requestPlain)
        let request: OMGRequest<DummyTestObject>? = client.request(toEndpoint: dummyEndpoint) { result in
            defer {
                expectation.fulfill()
            }
            switch result {
            case .success(data: _):
                XCTFail("Request should not be executed if base url is not correct")
            case .fail(let error):
                switch error {
                case .configuration(message: _):
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
