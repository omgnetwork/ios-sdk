//
//  SettingLiveTests.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 10/11/2017 BE.
//  Copyright © 2017 OmiseGO. All rights reserved.
//

import XCTest
@testable import OmiseGO

class SettingLiveTests: LiveTestCase {

    func testGetSettings() {
        let expectation = self.expectation(description: "Setting result")
        let request = Setting.get(using: self.testClient) { (result) in
            defer { expectation.fulfill() }
            switch result {
            case .success(let setting):
                XCTAssert(!setting.mintedTokens.isEmpty)
            case .fail(let error):
                XCTFail("\(error)")
            }
        }
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }

}
