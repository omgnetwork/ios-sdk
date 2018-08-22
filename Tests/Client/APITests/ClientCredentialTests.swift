//
//  ClientCredentialTests.swift
//  Tests
//
//  Created by Mederic Petit on 9/8/18.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

@testable import OmiseGO
import XCTest

class ClientCredentialTests: XCTestCase {
    func testUpdateCredentialSuccessfully() {
        var credentials = ClientCredential(apiKey: "api_key")
        XCTAssertNil(credentials.authenticationToken)
        let authenticationToken = StubGenerator.authenticationToken(token: "123")
        credentials.update(withAuthenticationToken: authenticationToken)
        XCTAssertEqual(credentials.authenticationToken, "123")
    }

    func testAuthenticationReturnsNilIfAuthenticationTokenIsNotSpecified() {
        var credentials = ClientCredential(apiKey: "api_key", authenticationToken: "auth_token")
        credentials.invalidate()
        XCTAssertNil(try credentials.authentication())
    }
}
