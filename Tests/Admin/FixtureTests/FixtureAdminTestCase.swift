//
//  FixtureAdminTestCase.swift
//  Tests
//
//  Created by Mederic Petit on 14/9/18.
//  Copyright © 2017-2019 Omise Go Pte. Ltd. All rights reserved.
//

import OmiseGO
import XCTest

class FixtureAdminTestCase: XCTestCase {
    var testClient: FixtureAdminAPI {
        let bundle = Bundle(for: FixtureAdminTestCase.self)
        let url = bundle.url(forResource: "admin_fixtures", withExtension: nil)!
        let credentials = AdminCredential(userId: "user_id", authenticationToken: "token")
        let config = AdminConfiguration(baseURL: "http://localhost:4000", credentials: credentials)
        return FixtureAdminAPI(fixturesDirectoryURL: url, config: config)
    }
}
