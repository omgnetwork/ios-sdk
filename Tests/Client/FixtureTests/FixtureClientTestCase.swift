//
//  FixtureClientTestCase.swift
//  Tests
//
//  Created by Mederic Petit on 10/10/2017.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

import OmiseGO
import XCTest

class FixtureClientTestCase: XCTestCase {
    var testClient: FixtureClient {
        let bundle = Bundle(for: FixtureClientTestCase.self)
        let url = bundle.url(forResource: "client_fixtures", withExtension: nil)!
        let credentials = ClientCredential(apiKey: "some_api_key", authenticationToken: "some_token")
        let config = ClientConfiguration(baseURL: "http://localhost:4000", credentials: credentials)
        return FixtureClient(fixturesDirectoryURL: url, config: config)
    }
}
