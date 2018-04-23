//
//  OMGErrorTests.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 7/3/18.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

import XCTest
@testable import OmiseGO

enum DummyError: Error {
    case dummy
}

class OMGErrorTests: XCTestCase {

    func testMessage() {
        let unexpectedError = OMGError.unexpected(message: "unexpected error")
        XCTAssertEqual(unexpectedError.message, "unexpected error: unexpected error")
        let configurationError = OMGError.configuration(message: "configuration error")
        XCTAssertEqual(configurationError.message, "configuration error: configuration error")
        let apiError = OMGError.api(apiError: .init(code: .invalidParameters, description: "api error description"))
        XCTAssertEqual(apiError.message, "api error description")
        let otherError = OMGError.other(error: DummyError.dummy)
        XCTAssertEqual(otherError.message, "I/O error: The operation couldn’t be completed. (OmiseGOTests.DummyError error 0.)")
    }

    func testLocalizedDescription() {
        let unexpectedError = OMGError.unexpected(message: "unexpected error")
        XCTAssertEqual(unexpectedError.localizedDescription, "unexpected error: unexpected error")
    }

    func testDescription() {
        let unexpectedError = OMGError.unexpected(message: "unexpected error")
        XCTAssertEqual(unexpectedError.description, "unexpected error: unexpected error")
    }

    func testDebugDescription() {
        let unexpectedError = OMGError.unexpected(message: "unexpected error")
        XCTAssertEqual(unexpectedError.debugDescription, "unexpected error: unexpected error")
    }

    func testErrorDescription() {
        let unexpectedError = OMGError.unexpected(message: "unexpected error")
        XCTAssertEqual(unexpectedError.errorDescription, "unexpected error: unexpected error")
    }

    func testEquatable() {
        let unexpected1 = OMGError.unexpected(message: "message")
        let unexpected2 = OMGError.unexpected(message: "message")
        let unexpected3 = OMGError.unexpected(message: "other")
        XCTAssertEqual(unexpected1, unexpected2)
        XCTAssertNotEqual(unexpected1, unexpected3)

        let configuration1 = OMGError.configuration(message: "message")
        let configuration2 = OMGError.configuration(message: "message")
        let configuration3 = OMGError.configuration(message: "other")
        XCTAssertEqual(configuration1, configuration2)
        XCTAssertNotEqual(configuration1, configuration3)

        let api1 = OMGError.api(apiError: .init(code: .accessTokenExpired, description: ""))
        let api2 = OMGError.api(apiError: .init(code: .accessTokenExpired, description: ""))
        let api3 = OMGError.api(apiError: .init(code: .channelNotFound, description: ""))
        XCTAssertEqual(api1, api2)
        XCTAssertNotEqual(api1, api3)

        let socket1 = OMGError.socketError(message: "message")
        let socket2 = OMGError.socketError(message: "message")
        let socket3 = OMGError.socketError(message: "other")
        XCTAssertEqual(socket1, socket2)
        XCTAssertNotEqual(socket1, socket3)
    }

}
