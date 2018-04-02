//
//  RequestFixtureTest.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 13/11/2017.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

import XCTest
@testable import OmiseGO

class RequestFixtureTest: FixtureTestCase {

    func testBuildRequest() {
        do {
            let requestParams = RequestParameters(config: self.testCustomClient.config)
            let urlRequest = try RequestBuilder(requestParameters: requestParams).buildHTTPURLRequest(withEndpoint: .custom(path: "", task: .requestPlain))
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
