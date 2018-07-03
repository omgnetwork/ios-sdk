//
//  UserLiveTests.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 18/10/2017.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

import Foundation
import OmiseGO
import XCTest

class UserLiveTests: LiveTestCase {
    func testCurrentUserRetrieve() {
        let expectation = self.expectation(description: "Get current user from authentication token")
        let request = User.getCurrent(using: self.testClient) { result in
            defer { expectation.fulfill() }
            switch result {
            case let .success(user):
                XCTAssertNotNil(user)
            case let .fail(error):
                XCTFail("\(error)")
            }
        }
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
}
