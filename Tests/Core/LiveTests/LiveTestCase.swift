//
//  LiveTestCase.swift
//  Tests
//
//  Created by Mederic Petit on 10/8/18.
//  Copyright © 2017-2019 Omise Go Pte. Ltd. All rights reserved.
//

import XCTest

class LiveTestCase: XCTestCase {
    private static let OMG_BASE_URL = "OMG_BASE_URL"
    private static let OMG_WEBSOCKET_URL = "OMG_WEBSOCKET_URL"
    private static let OMG_API_KEY = "OMG_API_KEY"
    private static let OMG_CLIENT_AUTHENTICATION_TOKEN = "OMG_CLIENT_AUTHENTICATION_TOKEN"
    private static let OMG_TOKEN_ID = "OMG_TOKEN_ID"

    var validWebsocketURL: String = ""
    var validBaseURL: String = ""
    var validAPIKey: String = ""
    var validAuthenticationToken: String = ""
    var validTokenId: String = ""

    let invalidWebsocketURL = "an invalid websocket url"
    let invalidBaseURL = "an invalid base url"
    let invalidAPIKey = "an invalid api key"
    let invalidAuthenticationToken = "an invalid authentication token"

    override func setUp() {
        super.setUp()
        self.continueAfterFailure = false
        self.loadEnvKeys()
        if !self.areKeysValid() {
            XCTFail("""
                Missing values for required constants.
                Replace them in secret.plist or pass them as environment variables.
            """)
        }
    }

    func areKeysValid() -> Bool {
        return
            self.validBaseURL != "" && self.validBaseURL != "$\(LiveTestCase.OMG_BASE_URL)"
            && self.validWebsocketURL != "" && self.validWebsocketURL != "$\(LiveTestCase.OMG_WEBSOCKET_URL)"
            && self.validAPIKey != "" && self.validAPIKey != "$\(LiveTestCase.OMG_API_KEY)"
            && self.validAuthenticationToken != "" && self.validAuthenticationToken != "$\(LiveTestCase.OMG_CLIENT_AUTHENTICATION_TOKEN)"
            && self.validTokenId != "" && self.validTokenId != "$\(LiveTestCase.OMG_TOKEN_ID)"
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
    /// OMG_TOKEN_ID="someTokenId" \
    /// test
    private func loadEnvKeys() {
        let plistSecrets = self.loadSecretPlistFile()
        self.validBaseURL =
            plistSecrets?[LiveTestCase.OMG_BASE_URL] != nil &&
            plistSecrets![LiveTestCase.OMG_BASE_URL] != "" ?
            plistSecrets![LiveTestCase.OMG_BASE_URL]! :
            ProcessInfo.processInfo.environment[LiveTestCase.OMG_BASE_URL]!
        self.validWebsocketURL =
            plistSecrets?[LiveTestCase.OMG_WEBSOCKET_URL] != nil &&
            plistSecrets![LiveTestCase.OMG_WEBSOCKET_URL] != "" ?
            plistSecrets![LiveTestCase.OMG_WEBSOCKET_URL]! :
            ProcessInfo.processInfo.environment[LiveTestCase.OMG_WEBSOCKET_URL]!
        self.validAPIKey =
            plistSecrets?[LiveTestCase.OMG_API_KEY] != nil &&
            plistSecrets![LiveTestCase.OMG_API_KEY] != "" ?
            plistSecrets![LiveTestCase.OMG_API_KEY]! :
            ProcessInfo.processInfo.environment[LiveTestCase.OMG_API_KEY]!
        self.validAuthenticationToken =
            plistSecrets?[LiveTestCase.OMG_CLIENT_AUTHENTICATION_TOKEN] != nil &&
            plistSecrets![LiveTestCase.OMG_CLIENT_AUTHENTICATION_TOKEN] != "" ?
            plistSecrets![LiveTestCase.OMG_CLIENT_AUTHENTICATION_TOKEN]! :
            ProcessInfo.processInfo.environment[LiveTestCase.OMG_CLIENT_AUTHENTICATION_TOKEN]!
        self.validTokenId =
            plistSecrets?[LiveTestCase.OMG_TOKEN_ID] != nil &&
            plistSecrets![LiveTestCase.OMG_TOKEN_ID] != "" ?
            plistSecrets![LiveTestCase.OMG_TOKEN_ID]! :
            ProcessInfo.processInfo.environment[LiveTestCase.OMG_TOKEN_ID]!
    }

    private func loadSecretPlistFile() -> [String: String]? {
        guard let path = Bundle(for: LiveTestCase.self).path(forResource: "secret", ofType: "plist") else { return nil }
        return NSDictionary(contentsOfFile: path) as? [String: String]
    }
}
