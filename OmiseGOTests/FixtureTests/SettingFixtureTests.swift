//
//  SettingFixtureTests.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 12/10/2017 BE.
//  Copyright © 2017 OmiseGO. All rights reserved.
//

import XCTest
@testable import OmiseGO

class SettingFixtureTests: FixtureTestCase {

    func testGetSettings() {
        let expectation = self.expectation(description: "Get settings for current user")
        let request = Setting.get(using: self.testCustomClient) { (result) in
            defer { expectation.fulfill() }
            switch result {
            case .success(let setting):
                XCTAssertTrue(setting.mintedTokens.count == 2)
                XCTAssertEqual(setting.mintedTokens[0].id, "BTC:123")
                XCTAssertEqual(setting.mintedTokens[0].symbol, "BTC")
                XCTAssertEqual(setting.mintedTokens[0].name, "Bitcoin")
                XCTAssertEqual(setting.mintedTokens[0].subUnitToUnit, 100000)
                XCTAssertEqual(setting.mintedTokens[1].id, "OMG:123")
                XCTAssertEqual(setting.mintedTokens[1].symbol, "OMG")
                XCTAssertEqual(setting.mintedTokens[1].name, "OmiseGO")
                XCTAssertEqual(setting.mintedTokens[1].subUnitToUnit, 100000000)
            case .fail(let error):
                XCTFail("\(error)")
            }
        }
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }

}
