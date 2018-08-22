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
    func testAuthenticationIsInvalidedAfterLogout() {
        let expectation = self.expectation(description: "Authentication should be nil after logout")
        XCTAssertNotNil(try! self.testClient.config.credentials.authentication())
        let client = self.testClient
        let request = client.logoutClient { _ in
            defer { expectation.fulfill() }
            XCTAssertNil(try! client.config.credentials.authentication())
        }
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
}
