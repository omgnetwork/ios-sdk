//
//  TestCredential.swift
//  Tests
//
//  Created by Mederic Petit on 9/8/18.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

@testable import OmiseGO

struct TestCredential: Credential {
    var authenticated: Bool

    init(authenticated: Bool) {
        self.authenticated = authenticated
    }

    func isAuthenticated() -> Bool {
        return self.authenticated
    }

    mutating func update(withAuthenticationToken _: AuthenticationToken) {
        self.authenticated = true
    }

    func authentication() throws -> String? {
        return self.authenticated ? "OMGClient \("123:123".data(using: .utf8)!.base64EncodedString())" : nil
    }

    mutating func invalidate() {
        self.authenticated = false
    }
}
