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

    let validBaseURL = "https://kubera.omisego.io"
    let validAPIKey = "1482qNxPey7A4_rrKkAOb4kAOTsD2HoLysS7eQ1Zd3Y"
    let validAuthenticationToken = "1Zacrsqt03FbKQkmD1EF9u_ERuK7Zu4sBSSsIJfQ84U"

    let invalidBaseURL = "an invalid base url"
    let invalidAPIKey = "an invalid api key"
    let invalidAuthenticationToken = "and invalid authentication token"

    override func setUp() {
        super.setUp()
        self.testClient = OMGClient(config: self.validConfig())
    }

    var testClient: OMGClient!

    private func validConfig() -> OMGConfiguration {
        return OMGConfiguration(baseURL: validBaseURL,
                                apiKey: validAPIKey,
                                authenticationToken: validAuthenticationToken)
    }

}
