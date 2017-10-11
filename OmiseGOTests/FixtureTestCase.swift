//
//  FixtureTestCase.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 10/10/2560 BE.
//  Copyright © 2560 OmiseGO. All rights reserved.
//

import XCTest
@testable import OmiseGO

class FixtureTestCase: OmiseGOTestCase {
    var testClient: FixtureClient {
        let url: String = "api.omisego.co"
        let apiKey: String = "apikey"
        let authenticationToken: String = "authenticationtoken"
        let config = APIConfiguration(baseURL: url, apiKey: apiKey, authenticationToken: authenticationToken)
        return FixtureClient(config: config)
    }

    func fixturesData(for filename: String) -> Data? {
        let bundle = Bundle(for: OmiseGOTestCase.self)
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

class SuccessTestObject: OmiseGOObject {

    var object: String = ""

}
