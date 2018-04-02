//
//  OMGRequestTest.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 6/2/2018.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

import XCTest
@testable import OmiseGO

class OMGRequestTest: XCTestCase {

    let client: OMGHTTPClient = OMGHTTPClient(config: OMGConfiguration(baseURL: "https://example.com",
                                                                       apiKey: "123",
                                                                       authenticationToken: "123"))

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
