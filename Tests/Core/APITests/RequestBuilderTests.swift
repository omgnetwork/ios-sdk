//
//  RequestBuilderTests.swift
//  Tests
//
//  Created by Mederic Petit on 21/3/18.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

@testable import OmiseGO
import XCTest

class RequestBuilderTests: XCTestCase {
    var httpConfig = TestConfiguration(credentials: TestCredential())
    var socketConfig = TestConfiguration(credentials: TestCredential())
    var requestBuilder: RequestBuilder!

    override func setUp() {
        super.setUp()
        self.requestBuilder = RequestBuilder(configuration: self.httpConfig)
    }

    func buildHttpRequestWithParams() {
        let dummyObject = TestObject(object: "object")
        let endpoint = TestAPIEndpoint(task: .requestParameters(parameters: dummyObject))
        do {
            let urlRequest = try self.requestBuilder.buildHTTPURLRequest(withEndpoint: endpoint)
            XCTAssertEqual(urlRequest.httpMethod, "POST")
            XCTAssertEqual(urlRequest.cachePolicy, .useProtocolCachePolicy)
            XCTAssertEqual(urlRequest.timeoutInterval, 6.0)
            XCTAssertEqual(urlRequest.httpBody!, dummyObject.encodedPayload()!)
            XCTAssertNotNil(urlRequest.allHTTPHeaderFields!["Authorization"])
            XCTAssertNotNil(urlRequest.allHTTPHeaderFields!["Accept"])
            XCTAssertNotNil(urlRequest.allHTTPHeaderFields!["Content-Type"])
        } catch let error {
            XCTFail(error.localizedDescription)
        }
    }

    func testBuildRequestWithoutParams() {
        do {
            let urlRequest = try self.requestBuilder.buildHTTPURLRequest(withEndpoint: TestAPIEndpoint())
            XCTAssertEqual(urlRequest.httpMethod, "POST")
            XCTAssertEqual(urlRequest.cachePolicy, .useProtocolCachePolicy)
            XCTAssertEqual(urlRequest.timeoutInterval, 6.0)
            XCTAssertEqual(urlRequest.httpBody, nil)
            XCTAssertNotNil(urlRequest.allHTTPHeaderFields!["Authorization"])
            XCTAssertNotNil(urlRequest.allHTTPHeaderFields!["Accept"])
            XCTAssertNotNil(urlRequest.allHTTPHeaderFields!["Content-Type"])
        } catch let error {
            XCTFail(error.localizedDescription)
        }
    }

    func testBuildWebsocketRequest() {
        do {
            let requestBuilder = RequestBuilder(configuration: self.socketConfig)
            let urlRequest = try requestBuilder.buildWebsocketRequest()
            XCTAssertEqual(urlRequest.httpMethod, "GET")
            XCTAssertEqual(urlRequest.timeoutInterval, 6.0)
            XCTAssertNotNil(urlRequest.allHTTPHeaderFields!["Authorization"])
            XCTAssertNotNil(urlRequest.allHTTPHeaderFields!["Accept"])
            XCTAssertNotNil(urlRequest.allHTTPHeaderFields!["Content-Type"])
        } catch let error {
            XCTFail(error.localizedDescription)
        }
    }

    func testEncodeAuthorizationHeaderSuccessfully() {
        XCTAssertEqual(
            try! self.httpConfig.credentials.authentication(),
            "OMGClient \("123:123".data(using: .utf8)!.base64EncodedString())"
        )
    }

    func testReturnCorrectContentTypeHeader() {
        XCTAssertEqual(self.requestBuilder.contentTypeHeader(), "application/vnd.omisego.v1+json; charset=utf-8")
    }

    func testReturnCorrectAcceptHeader() {
        XCTAssertEqual(self.requestBuilder.acceptHeader(), "application/vnd.omisego.v\(self.httpConfig.apiVersion)+json")
    }
}
