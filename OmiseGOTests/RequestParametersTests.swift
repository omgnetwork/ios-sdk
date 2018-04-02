//
//  RequestParametersTests.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 21/3/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import XCTest
@testable import OmiseGO

class RequestParametersTests: XCTestCase {

    var config = OMGConfiguration(baseURL: "https://example.com",
                                  apiKey: "123",
                                  authenticationToken: "123")
    var requestParameters: RequestParameters!

    override func setUp() {
        super.setUp()
        self.requestParameters = RequestParameters(config: self.config)
    }

    func testBaseURLIsCorrect() {
        XCTAssertEqual(self.requestParameters.baseURL(), self.config.baseURL)
    }

    func testEncodeAuthorizationHeaderCorrectly() {
        XCTAssertEqual(try! self.requestParameters.encodedAuthorizationHeader(),
                       "OMGClient \("123:123".data(using: .utf8)!.base64EncodedString())")
    }

    func testFailToEncodeAuthorizationHeaderIfAuthenticationTokenIsNotSpecified() {
        self.config.authenticationToken = nil
        self.requestParameters = RequestParameters(config: self.config)
        XCTAssertThrowsError(try self.requestParameters.encodedAuthorizationHeader())
    }

    func testReturnCorrectContentTypeHeader() {
        XCTAssertEqual(self.requestParameters.contentTypeHeader(), "application/vnd.omisego.v1+json; charset=utf-8")
    }

    func testReturnCorrectAcceptHeader() {
        XCTAssertEqual(self.requestParameters.acceptHeader(), "application/vnd.omisego.v\(self.config.apiVersion)+json")
    }

}
