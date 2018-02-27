//
//  RequestFixtureTest.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 13/11/2017 BE.
//  Copyright © 2017 OmiseGO. All rights reserved.
//

import XCTest
@testable import OmiseGO

class RequestFixtureTest: FixtureTestCase {

    func testBuildRequest() {
        let request: OMGRequest<DummyTestObject> =
            OMGRequest(client: self.testCustomClient,
                       endpoint: APIEndpoint.custom(path: "", task: .requestPlain)) { _ in}
        do {
            guard let urlRequest = try request.buildURLRequest() else {
                XCTFail("Failed to build the request")
                return
            }
            guard let httpHeaders = urlRequest.allHTTPHeaderFields else {
                XCTFail("Missing HTTP headers")
                return
            }
            XCTAssertEqual(httpHeaders["Authorization"], "OMGClient YXBpa2V5OmF1dGhlbnRpY2F0aW9udG9rZW4=")
            XCTAssertEqual(httpHeaders["Accept"],
                           "application/vnd.omisego.v\(self.testCustomClient.config.apiVersion)+json")
            XCTAssertEqual(httpHeaders["Content-Type"],
                           "application/vnd.omisego.v\(self.testCustomClient.config.apiVersion)+json; charset=utf-8")
            XCTAssertNil(urlRequest.httpBody)
            XCTAssertEqual(urlRequest.httpMethod, "POST")
            XCTAssertEqual(urlRequest.timeoutInterval, 6)
        } catch let error {
            XCTFail(error.localizedDescription)
        }
    }
}
