//
//  FixtureTestCase.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 10/10/2017 BE.
//  Copyright © 2017 OmiseGO. All rights reserved.
//

import XCTest
@testable import OmiseGO

class FixtureTestCase: XCTestCase {

    var testCustomClient: FixtureClient {
        return FixtureClient(config: self.validConfig)
    }

    let validConfig: OMGConfiguration = OMGConfiguration(baseURL: "api.omisego.co",
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
