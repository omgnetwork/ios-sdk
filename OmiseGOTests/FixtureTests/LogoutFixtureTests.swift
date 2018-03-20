//
//  LogoutFixtureTests.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 27/10/2017.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

import XCTest
@testable import OmiseGO

class LogoutFixtureTests: FixtureTestCase {

    func testLogout() {
        let expectation = self.expectation(description: "Check if authentication token is invalidated")
        XCTAssertNotNil(self.testCustomClient.config.authenticationToken)
        let client = self.testCustomClient
        let request = client.logout { (result) in
            defer { expectation.fulfill() }
            switch result {
            case .success(data: _):
                XCTAssertNil(client.config.authenticationToken)
            case .fail(error: let error):
                XCTFail("\(error)")
            }
        }
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }

    func testPerformQueryAfterLogout() {
        let expectation = self.expectation(description: "Check if other queries fail after logout")
        XCTAssertNotNil(self.testCustomClient.config.authenticationToken)
        let client = self.testCustomClient
        let request = client.logout { _ in
            defer { expectation.fulfill() }
            do {
                _ = try client.encodedAuthorizationHeader()
                XCTFail("Should not be able to encode header after logout")
            } catch let error as OmiseGOError {
                switch error {
                case .configuration(message: _):
                    XCTAssertTrue(true)
                default:
                    XCTFail("Should throw a configuration error")
                }
            } catch _ {}
        }
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }

}
