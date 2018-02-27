//
//  LiveTestCase.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 18/10/2017 BE.
//  Copyright © 2017 OmiseGO. All rights reserved.
//

import Foundation
import XCTest
import OmiseGO

class LiveTestCase: XCTestCase {

    /// Replace with yours!
    var validBaseURL = ""
    /// Replace with yours!
    var validAPIKey = ""
    /// Replace with yours!
    var validAuthenticationToken = ""

    let invalidBaseURL = "an invalid base url"
    let invalidAPIKey = "an invalid api key"
    let invalidAuthenticationToken = "an invalid authentication token"

    override func setUp() {
        super.setUp()
        self.continueAfterFailure = false
        self.loadEnvKeys()
        if !self.areKeysValid() {
            XCTFail("Replace base url, authentication token and API Key at the top of this file!")
        }
        self.testClient = OMGClient(config: self.validConfig())
    }

    var testClient: OMGClient!

    private func validConfig() -> OMGConfiguration {
        return OMGConfiguration(baseURL: validBaseURL,
                                apiKey: validAPIKey,
                                authenticationToken: validAuthenticationToken)
    }

    func areKeysValid() -> Bool {
        return !(self.validBaseURL == "" || self.validAPIKey == "" || self.validAuthenticationToken == "")
    }

    /// This function loads the keys from the environment variables,
    /// you can specify these vriable when running tests on a CI server like so
    /// xcodebuild -project OmiseGO.xcodeproj \
    /// -scheme "OmiseGO" \
    /// -sdk iphonesimulator \
    /// -destination 'platform=iOS Simulator,name=iPhone 8' \
    /// OMG_BASE_URL="https://some.base.url" \
    /// OMG_API_KEY="someKey" \
    /// OMG_AUTHENTICATION_TOKEN="someToken" \
    /// test
    private func loadEnvKeys() {
        self.validBaseURL = self.validBaseURL != "" ? self.validBaseURL :
            ProcessInfo.processInfo.environment["OMG_BASE_URL"]!
        self.validAPIKey = self.validAPIKey != "" ? self.validAPIKey :
            ProcessInfo.processInfo.environment["OMG_API_KEY"]!
        self.validAuthenticationToken = self.validAuthenticationToken != "" ? self.validAuthenticationToken :
            ProcessInfo.processInfo.environment["OMG_AUTHENTICATION_TOKEN"]!
    }

}
