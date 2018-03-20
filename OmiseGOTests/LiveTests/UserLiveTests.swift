//
//  UserLiveTests.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 18/10/2017.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

import Foundation
import XCTest
import OmiseGO

class UserLiveTests: LiveTestCase {

    func testCurrentUserRetrieve() {
        let expectation = self.expectation(description: "Get current user from authentication token")
        let request = User.getCurrent(using: self.testClient) { (result) in
            defer { expectation.fulfill() }
            switch result {
            case .success(let user):
                XCTAssertNotNil(user)
            case .fail(let error):
                XCTFail("\(error)")
            }
        }
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }

}
