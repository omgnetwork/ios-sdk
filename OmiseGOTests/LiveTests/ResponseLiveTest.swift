//
//  ResponseLiveTest.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 18/10/2017.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

@testable import OmiseGO
import XCTest

class ResponseLiveTest: LiveTestCase {
    func testWrongEndpoint() {
        let expectation = self.expectation(description: "Error response")
        let endpoint = APIEndpoint.custom(path: "/not_exising", task: .requestPlain)
        let request: Request<DummyTestObject>? = self.testClient.request(toEndpoint: endpoint) { result in
            defer { expectation.fulfill() }
            switch result {
            case .success(data: _):
                XCTFail("Should not succeed")
            case let .fail(error):
                switch error {
                case let .api(apiError: apiError):
                    XCTAssertEqual(apiError.code, .endPointNotFound)
                default:
                    XCTFail("Error should be an API error")
                }
            }
        }
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
}
