//
//  SignupFixtureTests.swift
//  Tests
//
//  Created by Mederic Petit on 22/8/18.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

@testable import OmiseGO
import XCTest

class SignupFixtureTests: XCTestCase {
    var testClient: FixtureClientAPI {
        let bundle = Bundle(for: FixtureClientTestCase.self)
        let url = bundle.url(forResource: "client_fixtures", withExtension: nil)!
        let credentials = ClientCredential(apiKey: "some_api_key")
        let config = ClientConfiguration(baseURL: "http://localhst:4000", credentials: credentials)
        return FixtureClientAPI(fixturesDirectoryURL: url, config: config)
    }

    func testSignupSuccessfully() {
        let expectation = self.expectation(description: "Signup a user successfully")
        XCTAssertNil(try! self.testClient.config.credentials.authentication())
        let client = self.testClient
        let params = SignupParams(email: "email@example.com",
                                  password: "password",
                                  passwordConfirmation: "password")
        let request = client.signup(withParams: params) { result in
            defer { expectation.fulfill() }
            switch result {
            case let .fail(error: error):
                XCTFail(error.message)
            case .success(data: _): break
            }
        }
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
}
