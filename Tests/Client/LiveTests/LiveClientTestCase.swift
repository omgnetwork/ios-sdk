//
//  LiveClientTestCase.swift
//  Tests
//
//  Created by Mederic Petit on 18/10/2017.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

import OmiseGO
import XCTest

class LiveClientTestCase: LiveTestCase {
    var testClient: HTTPClient!
    var testSocketClient: SocketClient!

    override func setUp() {
        super.setUp()
        self.testClient = HTTPClient(config: self.validHTTPConfig())
        self.testSocketClient = SocketClient(config: self.validSocketConfig(), delegate: nil)
    }

    private func validHTTPConfig() -> ClientConfiguration {
        let credentials = ClientCredential(apiKey: self.validAPIKey,
                                           authenticationToken: self.validAuthenticationToken)
        return ClientConfiguration(baseURL: self.validBaseURL, credentials: credentials)
    }

    private func validSocketConfig() -> ClientConfiguration {
        let credentials = ClientCredential(apiKey: self.validAPIKey,
                                           authenticationToken: self.validAuthenticationToken)
        return ClientConfiguration(baseURL: self.validWebsocketURL, credentials: credentials)
    }
}
