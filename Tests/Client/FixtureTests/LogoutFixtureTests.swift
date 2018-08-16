//
//  LogoutFixtureTests.swift
//  Tests
//
//  Created by Mederic Petit on 27/10/2017.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

@testable import OmiseGO
import XCTest

class LogoutFixtureTests: FixtureClientTestCase {
    func testPerformQueryAfterLogout() {
        let expectation = self.expectation(description: "Check if other queries fail after logout")
        XCTAssertNotNil(try! self.testClient.config.credentials.authentication())
        let client = self.testClient
        let request = client.logoutClient { _ in
            defer { expectation.fulfill() }
            do {
                _ = try client.config.credentials.authentication()
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
