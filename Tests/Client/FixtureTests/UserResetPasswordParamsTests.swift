//
//  UserResetPasswordParamsTests.swift
//  Tests
//
//  Created by Mederic Petit on 4/4/19.
//  Copyright © 2019 Omise Go Pte. Ltd. All rights reserved.
//

import OmiseGO
import XCTest

class UserResetPasswordParamsTests: XCTestCase {
    func testDefaultResetPasswordURL() {
        let credentials = ClientCredential(apiKey: "apiKey")
        let config = ClientConfiguration(baseURL: "https://example.com", credentials: credentials)
        let httpClient = HTTPClientAPI(config: config)
        let url = UserResetPasswordParams.defaultResetPasswordURL(forClient: httpClient)
        XCTAssertEqual(url, "https://example.com/client/reset_password?email={email}&token={token}")
    }
}
