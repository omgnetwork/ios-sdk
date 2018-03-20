//
//  ResponseLiveTest.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 18/10/2017.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

import XCTest
@testable import OmiseGO

class ResponseLiveTest: LiveTestCase {

    func testWrongEndpoint() {
        let expectation = self.expectation(description: "Error response")
        let endpoint = APIEndpoint.custom(path: "/not_exising", task: .requestPlain)
        let request: OMGRequest<DummyTestObject>? = self.testClient.request(toEndpoint: endpoint) { (result) in
            defer { expectation.fulfill() }
            switch result {
            case .success(data: _):
                XCTFail("Should not succeed")
            case .fail(let error):
                switch error {
                case .api(apiError: let apiError):
                    switch apiError.code {
                    case .endPointNotFound: XCTAssertTrue(true)
                    default: XCTFail("Error should be endpoint not found")
                    }
                default:
                    XCTFail("Error should be an API error")
                }
            }
        }
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }

}
