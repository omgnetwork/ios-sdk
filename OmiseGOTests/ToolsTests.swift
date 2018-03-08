//
//  ToolsTests.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 7/3/18.
//  Copyright © 2018 OmiseGO. All rights reserved.
//

import XCTest
@testable import OmiseGO

class ToolsTests: XCTestCase {

    func testDateToString() {
        let date = Date(timeIntervalSince1970: 0)
        let defaultFormat = date.toString(timeZone: TimeZone(secondsFromGMT: 0))
        XCTAssertEqual(defaultFormat, "1970-01-01T00:00:00Z")
        let customFormat = date.toString(withFormat: "yyyy MM dd HH:mm:ss")
        XCTAssertEqual(customFormat, "1970 01 01 07:00:00")
    }

    func testDecodingContainerProtocol() {

    }

}
