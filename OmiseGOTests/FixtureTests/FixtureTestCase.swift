//
//  FixtureTestCase.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 10/10/2017.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

import OmiseGO
import XCTest

class FixtureTestCase: XCTestCase {
    var testClient: FixtureClient {
        return FixtureClient(config: self.validConfig)
    }

    let validConfig: ClientConfiguration = ClientConfiguration(baseURL: "https://example.com",
                                                               apiKey: "apikey",
                                                               authenticationToken: "authenticationtoken")

    func fixturesData(for filename: String) -> Data? {
        let bundle = Bundle(for: FixtureTestCase.self)
        guard let path = bundle.path(forResource: filename, ofType: "json") else {
            XCTFail("could not load fixtures.")
            return nil
        }

        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            XCTFail("could not load fixtures at path: \(path)")
            return nil
        }

        return data
    }
}
