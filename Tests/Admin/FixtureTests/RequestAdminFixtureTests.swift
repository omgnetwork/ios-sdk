//
//  RequestAdminFixtureTests.swift
//  Tests
//
//  Created by Mederic Petit on 17/9/18.
//  Copyright © 2017-2019 Omise Go Pte. Ltd. All rights reserved.
//

@testable import OmiseGO
import XCTest

class RequestAdminFixtureTests: FixtureAdminTestCase {
    func testBuildRequest() {
        do {
            let urlRequest = try RequestBuilder(configuration: testClient.config)
                .buildHTTPURLRequest(withEndpoint: TestAPIEndpoint())

            guard let httpHeaders = urlRequest.allHTTPHeaderFields else {
                XCTFail("Missing HTTP headers")
                return
            }

            XCTAssertEqual(httpHeaders["Authorization"], "OMGAdmin dXNlcl9pZDp0b2tlbg==")
            XCTAssertEqual(httpHeaders["Accept"],
                           "application/vnd.omisego.v\(self.testClient.config.apiVersion)+json")
            XCTAssertEqual(httpHeaders["Content-Type"],
                           "application/vnd.omisego.v\(self.testClient.config.apiVersion)+json; charset=utf-8")
            XCTAssertNil(urlRequest.httpBody)
            XCTAssertEqual(urlRequest.httpMethod, "POST")
            XCTAssertEqual(urlRequest.timeoutInterval, 6)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
