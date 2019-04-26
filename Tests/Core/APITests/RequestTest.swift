//
//  RequestTest.swift
//  Tests
//
//  Created by Mederic Petit on 6/2/2018.
//  Copyright © 2017-2019 Omise Go Pte. Ltd. All rights reserved.
//

@testable import OmiseGO
import XCTest

class RequestTest: XCTestCase {
    let client: HTTPAPI = HTTPAPI(config: TestConfiguration())

    func testStartRequest() {
        let request: Request<TestObject> =
            Request(client: client, endpoint: TestAPIEndpoint()) { _ in }
        do {
            XCTAssertNil(request.task)
            _ = try request.start()
            XCTAssertNotNil(request.task)
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

    func testCancelRequest() {
        let expectation = self.expectation(description: "Task is cancelled")
        let dummyEndpoint = TestAPIEndpoint()
        let request: Request<TestObject> =
            Request(client: client,
                    endpoint: dummyEndpoint) { result in
                defer { expectation.fulfill() }
                switch result {
                case .success: XCTFail("Expected failure")
                case let .failure(error):
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
        } catch {
            XCTFail(error.localizedDescription)
        }
    }
}
