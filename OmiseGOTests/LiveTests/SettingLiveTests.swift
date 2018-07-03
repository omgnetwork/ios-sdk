//
//  SettingLiveTests.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 10/11/2017.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

import OmiseGO
import XCTest

class SettingLiveTests: LiveTestCase {
    func testGetSettings() {
        let expectation = self.expectation(description: "Setting result")
        let request = Setting.get(using: self.testClient) { result in
            defer { expectation.fulfill() }
            switch result {
            case let .success(setting):
                XCTAssert(!setting.tokens.isEmpty)
            case let .fail(error):
                XCTFail("\(error)")
            }
        }
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
}
