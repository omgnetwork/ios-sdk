//
//  LogoutFixtureTests.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 27/10/2017.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

@testable import OmiseGO
import XCTest

class LogoutFixtureTests: FixtureTestCase {
    func testLogout() {
        let expectation = self.expectation(description: "Check if authentication token is invalidated")
        XCTAssertNotNil(self.testClient.config.authenticationToken)
        let client = self.testClient
        let request = client.logout { result in
            defer { expectation.fulfill() }
            switch result {
            case .success(data: _):
                XCTAssertNil(client.config.authenticationToken)
            case let .fail(error: error):
                XCTFail("\(error)")
            }
        }
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }

    func testPerformQueryAfterLogout() {
        let expectation = self.expectation(description: "Check if other queries fail after logout")
        XCTAssertNotNil(self.testClient.config.authenticationToken)
        let client = self.testClient
        let request = client.logout { _ in
            defer { expectation.fulfill() }
            do {
                _ = try RequestBuilder(configuration: client.config).encodedAuthorizationHeader()
                XCTFail("Should not be able to encode header after logout")
            } catch let error as OMGError {
                switch error {
                case .configuration(message: _): break
                default: XCTFail("Should throw a configuration error")
                }
            } catch _ {}
        }
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
}
