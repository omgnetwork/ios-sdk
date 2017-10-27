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
        OMGClient.setup(withConfig: self.validConfig())
    }

    var testClient: OMGClient {
        return OMGClient(config: self.validConfig())
    }

    private func validConfig() -> OMGConfiguration {
        return OMGConfiguration(baseURL: "http://localhost:4000", apiKey: "", authenticationToken: "")
    }

}
