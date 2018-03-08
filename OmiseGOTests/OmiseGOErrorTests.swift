//
//  OmiseGOErrorTests.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 7/3/18.
//  Copyright © 2018 OmiseGO. All rights reserved.
//

import XCTest
@testable import OmiseGO

enum DummyError: Error {
    case dummy
}

class OmiseGOErrorTests: XCTestCase {

    func testMessage() {
        let unexpectedError = OmiseGOError.unexpected(message: "unexpected error")
        XCTAssertEqual(unexpectedError.message, "unexpected error: unexpected error")
        let configurationError = OmiseGOError.configuration(message: "configuration error")
        XCTAssertEqual(configurationError.message, "configuration error: configuration error")
        let apiError = OmiseGOError.api(apiError: .init(code: .invalidParameters, description: "api error description"))
        XCTAssertEqual(apiError.message, "api error description")
        let otherError = OmiseGOError.other(error: DummyError.dummy)
        XCTAssertEqual(otherError.message,
                       "I/O error: The operation couldn’t be completed. (OmiseGOTests.DummyError error 0.)")
    }

    func testLocalizedDescription() {
        let unexpectedError = OmiseGOError.unexpected(message: "unexpected error")
        XCTAssertEqual(unexpectedError.localizedDescription, "unexpected error: unexpected error")
    }

    func testDescription() {
        let unexpectedError = OmiseGOError.unexpected(message: "unexpected error")
        XCTAssertEqual(unexpectedError.description, "unexpected error: unexpected error")
    }

    func testDebugDescription() {
        let unexpectedError = OmiseGOError.unexpected(message: "unexpected error")
        XCTAssertEqual(unexpectedError.debugDescription, "unexpected error: unexpected error")
    }

    func testErrorDescription() {
        let unexpectedError = OmiseGOError.unexpected(message: "unexpected error")
        XCTAssertEqual(unexpectedError.errorDescription, "unexpected error: unexpected error")
    }

}
