//
//  LoginFixtureTests.swift
//  Tests
//
//  Created by Mederic Petit on 15/8/18.
//  Copyright © 2017-2019 Omise Go Pte. Ltd. All rights reserved.
//

@testable import OmiseGO
import XCTest

class LoginFixtureTests: XCTestCase {
    var testClient: FixtureClientAPI {
        let bundle = Bundle(for: FixtureClientTestCase.self)
        let url = bundle.url(forResource: "client_fixtures", withExtension: nil)!
        let credentials = ClientCredential(apiKey: "some_api_key")
        let config = ClientConfiguration(baseURL: "http://localhst:4000", credentials: credentials)
        return FixtureClientAPI(fixturesDirectoryURL: url, config: config)
    }

    func testLoginSuccessfullyAndUpdateToken() {
        let expectation = self.expectation(description: "Log a user in successfully and updates the client authentication")
        XCTAssertNil(try! self.testClient.config.credentials.authentication())
        let client = self.testClient
        let params = LoginParams(email: "email", password: "password")
        let request = client.login(withParams: params, callback: { result in
            defer { expectation.fulfill() }
            switch result {
            case let .failure(error):
                XCTFail(error.message)
            case let .success(data: authenticationToken):
                XCTAssertEqual(authenticationToken.token, "azJRj09l7jvR8KhTqUs3")
                XCTAssertEqual(authenticationToken.user.id, "usr_01cc02x0v98qcctvycfx4vsk8x")
                XCTAssertNotNil(try! client.config.credentials.authentication())
            }
        })
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
}
