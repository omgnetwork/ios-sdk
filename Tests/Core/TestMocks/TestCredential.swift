//
//  TestCredential.swift
//  Tests
//
//  Created by Mederic Petit on 9/8/18.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

@testable import OmiseGO

struct TestCredential: Credential {
    mutating func update(withAuthenticationToken _: AuthenticationToken) {}

    func authentication() throws -> String? {
        return "OMGClient \("123:123".data(using: .utf8)!.base64EncodedString())"
    }

    mutating func invalidate() {}
}
