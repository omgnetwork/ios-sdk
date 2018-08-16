//
//  RequestFixtureTest.swift
//  Tests
//
//  Created by Mederic Petit on 13/11/2017.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

@testable import OmiseGO
import XCTest

class RequestFixtureTest: FixtureClientTestCase {
    func testBuildRequest() {
        do {
            let urlRequest = try RequestBuilder(configuration: testClient.config)
                .buildHTTPURLRequest(withEndpoint: TestAPIEndpoint())

            guard let httpHeaders = urlRequest.allHTTPHeaderFields else {
                XCTFail("Missing HTTP headers")
                return
            }

            XCTAssertEqual(httpHeaders["Authorization"], "OMGClient c29tZV9hcGlfa2V5OnNvbWVfdG9rZW4=")
            XCTAssertEqual(httpHeaders["Accept"],
                           "application/vnd.omisego.v\(self.testClient.config.apiVersion)+json")
            XCTAssertEqual(httpHeaders["Content-Type"],
                           "application/vnd.omisego.v\(self.testClient.config.apiVersion)+json; charset=utf-8")
            XCTAssertNil(urlRequest.httpBody)
            XCTAssertEqual(urlRequest.httpMethod, "POST")
            XCTAssertEqual(urlRequest.timeoutInterval, 6)
        } catch let error {
            XCTFail(error.localizedDescription)
        }
    }
}
