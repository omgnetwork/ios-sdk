//
//  LiveTest.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 18/10/2560 BE.
//  Copyright © 2560 OmiseGO. All rights reserved.
//

import Foundation
import XCTest
import OmiseGO

class LiveTest: OmiseGOTestCase {

    override func setUp() {
        super.setUp()
        APIClient.setup(withConfig: self.validConfig())
    }

    var testClient: APIClient {
        return APIClient(config: self.validConfig())
    }

    private func validConfig() -> APIConfiguration {
        return APIConfiguration(baseURL: "http://localhost:4000", apiKey: "", authenticationToken: "")
    }

}
