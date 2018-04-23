//
//  HTTPClientTests.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 11/10/2017.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

import XCTest
@testable import OmiseGO

class HTTPClientTests: XCTestCase {

    func testInvalidURL() {
        let expectation = self.expectation(description: "Invalid url")
        let URL: String = "invalid url @"
        let socketURL: String = "invalid socket url @"
        let apiKey: String = "dummy_apikey"
        let authenticationToken: String = "dummy_authenticationtoken"
        let config = ClientConfiguration(baseURL: URL,
                                         apiKey: apiKey,
                                         authenticationToken: authenticationToken)
        let client = HTTPClient(config: config)
        let dummyEndpoint = APIEndpoint.custom(path: "dummy_action", task: .requestPlain)
        let request: Request<DummyTestObject>? = client.request(toEndpoint: dummyEndpoint) { result in
            defer {
                expectation.fulfill()
            }
            switch result {
            case .success(data: _):
                XCTFail("Request should not be executed if base url is not correct")
            case .fail(let error):
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
