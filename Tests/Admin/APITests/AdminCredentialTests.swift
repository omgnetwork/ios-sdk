//
//  AdminCredentialTests.swift
//  Tests
//
//  Created by Mederic Petit on 14/9/18.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

@testable import OmiseGO
import XCTest

class AdminCredentialTests: XCTestCase {
    func testIsAuthenticatedIsFalseWithoutAUserId() {
        var credentials = AdminCredential()
        credentials.authenticationToken = "123"
        XCTAssertFalse(credentials.isAuthenticated())
    }

    func testIsAuthenticatedIsFalseWithoutAToken() {
        var credentials = AdminCredential()
        credentials.userId = "123"
        XCTAssertFalse(credentials.isAuthenticated())
    }

    func testIsAuthenticatedIsTrueWithAUserIdAndAToken() {
        let credentials = AdminCredential(userId: "123", authenticationToken: "123")
        XCTAssertTrue(credentials.isAuthenticated())
    }

    func testUpdateCredentialSuccessfully() {
        var credentials = AdminCredential()
        XCTAssertNil(credentials.userId)
        XCTAssertNil(credentials.authenticationToken)
        let authenticationToken = StubGenerator.authenticationToken(token: "token", user: StubGenerator.user(id: "user_id"))
        credentials.update(withAuthenticationToken: authenticationToken)
        XCTAssertEqual(credentials.authenticationToken, "token")
        XCTAssertEqual(credentials.userId, "user_id")
    }

    func testAuthenticationReturnsNilAfterInvalidating() {
        var credentials = AdminCredential(userId: "123", authenticationToken: "123")
        credentials.invalidate()
        XCTAssertNil(try credentials.authentication())
    }
}
