//
//  OMGRequestTest.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 6/2/2018 BE.
//  Copyright © 2018 OmiseGO. All rights reserved.
//

import XCTest
@testable import OmiseGO

class OMGRequestTest: XCTestCase {

    let client: OMGClient = OMGClient(config: OMGConfiguration(baseURL: "https://example.com",
                                                               apiKey: "123",
                                                               authenticationToken: "123"))

    let validTransactionConsumeParams = StubGenerator.transactionConsumeParams()

    func testBuildRequestWithParams() {
        let dummyObject = DummyTestObject(object: "object")
        let request: OMGRequest<DummyTestObject> =
            OMGRequest(client: client,
                       endpoint: APIEndpoint.custom(path: "/test",
                                                    task: Task.requestParameters(parameters: dummyObject))) { _ in }
        do {
            let urlRequest: URLRequest = try request.buildURLRequest()!
            XCTAssertEqual(urlRequest.httpMethod, "POST")
            XCTAssertEqual(urlRequest.cachePolicy, .useProtocolCachePolicy)
            XCTAssertEqual(urlRequest.timeoutInterval, 6.0)

            XCTAssertEqual(urlRequest.allHTTPHeaderFields!["Authorization"], try client.encodedAuthorizationHeader())
            XCTAssertEqual(urlRequest.allHTTPHeaderFields!["Accept"], client.acceptHeader())
            XCTAssertEqual(urlRequest.allHTTPHeaderFields!["Content-Type"], client.contentTypeHeader())
            XCTAssertEqual(urlRequest.httpBody!, dummyObject.encodedPayload()!)
        } catch let error {
            XCTFail(error.localizedDescription)
        }
    }

    func testBuildRequestWithAdditionalHeaderFromParams() {
        let request: OMGRequest<DummyTestObject> =
            OMGRequest(client: self.client,
                       endpoint: .transactionRequestConsume(params: self.validTransactionConsumeParams),
                       callback: nil)
        do {
            let urlRequest: URLRequest = try request.buildURLRequest()!
            XCTAssertEqual(urlRequest.allHTTPHeaderFields!["Idempotency-Token"],
                           self.validTransactionConsumeParams.idempotencyToken)
        } catch let error {
            XCTFail(error.localizedDescription)
        }
    }

    func testBuildRequestWithoutParams() {
        let request: OMGRequest<DummyTestObject> =
            OMGRequest(client: client,
                       endpoint: APIEndpoint.custom(path: "/test",
                                                    task: Task.requestPlain)) { _ in }
        do {
            let urlRequest: URLRequest = try request.buildURLRequest()!
            XCTAssertEqual(urlRequest.httpMethod, "POST")
            XCTAssertEqual(urlRequest.cachePolicy, .useProtocolCachePolicy)
            XCTAssertEqual(urlRequest.timeoutInterval, 6.0)

            XCTAssertEqual(urlRequest.allHTTPHeaderFields!["Authorization"], try client.encodedAuthorizationHeader())
            XCTAssertEqual(urlRequest.allHTTPHeaderFields!["Accept"], client.acceptHeader())
            XCTAssertEqual(urlRequest.allHTTPHeaderFields!["Content-Type"], client.contentTypeHeader())
            XCTAssertEqual(urlRequest.httpBody, nil)
        } catch let error {
            XCTFail(error.localizedDescription)
        }
    }

    func testStartRequest() {
        let request: OMGRequest<DummyTestObject> =
            OMGRequest(client: client,
                       endpoint: APIEndpoint.custom(path: "/test",
                                                    task: Task.requestPlain)) { _ in}
        do {
            XCTAssertNil(request.task)
            _ = try request.start()
            XCTAssertNotNil(request.task)
        } catch let error {
            XCTFail(error.localizedDescription)
        }
    }

    func testCancelRequest() {
        let request: OMGRequest<DummyTestObject> =
            OMGRequest(client: client,
                       endpoint: APIEndpoint.custom(path: "/test",
                                                    task: Task.requestPlain)) { _ in}
        do {
            XCTAssertNil(request.task)
            _ = try request.start()
            XCTAssertNotNil(request.task)
            request.cancel()
            XCTAssertEqual(request.task!.state, .canceling)
        } catch let error {
            XCTFail(error.localizedDescription)
        }
    }

}
