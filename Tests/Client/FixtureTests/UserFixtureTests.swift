//
//  UserFixtureTests.swift
//  Tests
//
//  Created by Mederic Petit on 11/10/2017.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

import OmiseGO
import XCTest

class UserFixtureTests: FixtureClientTestCase {
    func testGetCurrentUser() {
        let expectation = self.expectation(description: "Get current user")
        let request = User.getCurrent(using: self.testClient) { result in
            defer { expectation.fulfill() }
            switch result {
            case let .success(user):
                XCTAssertEqual(user.id, "cec34607-0761-4a59-8357-18963e42a1aa")
                XCTAssertEqual(user.providerUserId, "wijf-fbancomw-dqwjudb")
                XCTAssertEqual(user.username, "john.doe@example.com")
                XCTAssertEqual(user.metadata["first_name"] as? String, "John")
                XCTAssertEqual(user.metadata["last_name"] as? String, "Doe")
                XCTAssertEqual(user.socketTopic, "user:cec34607-0761-4a59-8357-18963e42a1aa")
                if let object = user.metadata["object"] as? [String: Any] {
                    XCTAssertEqual(object["my_key"] as? String, "my_value")
                    if let nestedObject = object["my_nested_object"] as? [String: Any] {
                        XCTAssertEqual(nestedObject["my_nested_key"] as? String, "my_nested_value")
                    } else {
                        XCTFail("Failed to parse metadata nested object")
                    }
                } else {
                    XCTFail("Failed to parse metadata object")
                }
                if let array = user.metadata["array"] as? [Any] {
                    XCTAssertEqual(array[0] as? String, "value_1")
                    XCTAssertEqual(array[1] as? String, "value_2")
                } else {
                    XCTFail("Failed to parse metadata array")
                }
                XCTAssertTrue(user.encryptedMetadata.isEmpty)
                XCTAssertEqual(user.createdAt, "2018-01-01T00:00:00Z".toDate())
                XCTAssertEqual(user.updatedAt, "2018-01-01T00:00:00Z".toDate())
            case let .fail(error):
                XCTFail("\(error)")
            }
        }
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }

    func testResetPassword() {
        let expectation = self.expectation(description: "Reset password")
        let params = StubGenerator.resetPasswordParams()
        let request = User.resetPassword(using: self.testClient, params: params) { result in
            switch result {
            case let .fail(error: error):
                XCTFail("\(error)")
            case .success: break
            }
            expectation.fulfill()
        }
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }

    func testUpdatePassword() {
        let expectation = self.expectation(description: "Update password")
        let params = StubGenerator.updatePasswordParams()
        let request = User.updatePassword(using: self.testClient, params: params) { result in
            switch result {
            case let .fail(error: error):
                XCTFail("\(error)")
            case .success: break
            }
            expectation.fulfill()
        }
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
}
