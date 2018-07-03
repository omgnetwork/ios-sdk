//
//  DecodingFixtureTests.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 25/6/18.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

@testable import OmiseGO
import XCTest

class DecodingFixtureTests: FixtureTestCase {
    func testFailToDecodeANumberWhenExpectingAString() {
        let e = self.expectation(description: "Raise a decoding error")
        let endpoint = APIEndpoint.custom(path: "dummy.decoding_error", task: .requestPlain)
        let request: Request<DummyTestObject>? = self.testClient.request(toEndpoint: endpoint) { result in
            switch result {
            case .success(data: _): XCTFail("Excpected a decoding error")
            case let .fail(error: error):
                defer { e.fulfill() }
                XCTAssertEqual(error.message, "decoding error: Expected to decode String but found a number instead.")
            }
        }
        self.waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNotNil(request)
    }
}
