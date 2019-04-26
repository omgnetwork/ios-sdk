//
//  FixtureTestCase.swift
//  Tests
//
//  Created by Mederic Petit on 10/10/2017.
//  Copyright © 2017-2019 Omise Go Pte. Ltd. All rights reserved.
//

import OmiseGO
import XCTest

class FixtureTestCase: XCTestCase {
    var testClient: FixtureCoreAPI {
        let bundle = Bundle(for: FixtureTestCase.self)
        let url = bundle.url(forResource: "core_fixtures", withExtension: nil)!
        let config = TestConfiguration()
        return FixtureCoreAPI(fixturesDirectoryURL: url, config: config)
    }
}
