//
//  SettingFixtureTests.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 12/10/2017.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

import OmiseGO
import XCTest

class SettingFixtureTests: FixtureTestCase {
    func testGetSettings() {
        let expectation = self.expectation(description: "Get settings for current user")
        let request = Setting.get(using: self.testClient) { result in
            defer { expectation.fulfill() }
            switch result {
            case let .success(setting):
                XCTAssertTrue(setting.tokens.count == 2)
                XCTAssertEqual(setting.tokens[0].id, "BTC:123")
                XCTAssertEqual(setting.tokens[0].symbol, "BTC")
                XCTAssertEqual(setting.tokens[0].name, "Bitcoin")
                XCTAssertEqual(setting.tokens[0].subUnitToUnit, 100_000)
                XCTAssertTrue(setting.tokens[0].metadata.isEmpty)
                XCTAssertTrue(setting.tokens[0].encryptedMetadata.isEmpty)
                XCTAssertEqual(setting.tokens[0].createdAt, "2018-01-01T00:00:00Z".toDate())
                XCTAssertEqual(setting.tokens[0].updatedAt, "2018-01-01T00:00:00Z".toDate())
                XCTAssertEqual(setting.tokens[1].id, "OMG:123")
                XCTAssertEqual(setting.tokens[1].symbol, "OMG")
                XCTAssertEqual(setting.tokens[1].name, "OmiseGO")
                XCTAssertEqual(setting.tokens[1].subUnitToUnit, 100_000_000)
                XCTAssertTrue(setting.tokens[1].metadata.isEmpty)
                XCTAssertTrue(setting.tokens[1].encryptedMetadata.isEmpty)
                XCTAssertEqual(setting.tokens[1].createdAt, "2018-01-01T00:00:00Z".toDate())
                XCTAssertEqual(setting.tokens[1].updatedAt, "2018-01-01T00:00:00Z".toDate())
            case let .fail(error):
                XCTFail("\(error)")
            }
        }
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
}
