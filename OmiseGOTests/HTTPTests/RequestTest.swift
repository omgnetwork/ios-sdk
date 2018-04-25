//
//  RequestTest.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 6/2/2018.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

import XCTest
@testable import OmiseGO

class RequestTest: XCTestCase {

    let client: HTTPClient = HTTPClient(config: ClientConfiguration(baseURL: "https://example.com",
                                                                    apiKey: "123",
                                                                    authenticationToken: "123"))

    func testStartRequest() {
        let request: Request<DummyTestObject> =
            Request(client: client,
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
        let expectation = self.expectation(description: "Task is cancelled")
        let dummyEndpoint = APIEndpoint.custom(path: "/test", task: Task.requestPlain)
        let request: Request<DummyTestObject> =
            Request(client: client,
                    endpoint: dummyEndpoint) { result in
                        defer { expectation.fulfill() }
                        switch result {
                        case .success: XCTFail("Expected failure")
                        case .fail(error: let error):
                            XCTAssertEqual(error.description, "I/O error: cancelled")
                        }
        }
        do {
            XCTAssertNil(request.task)
            _ = try request.start()
            XCTAssertNotNil(request.task)
            request.cancel()
            self.wait(for: [expectation], timeout: 10)
            XCTAssertEqual(request.task!.state, .completed)
        } catch let error {
            XCTFail(error.localizedDescription)
        }
    }

}
