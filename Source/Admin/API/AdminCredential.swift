//
//  AdminCredential.swift
//  OmiseGO
//
//  Created by Mederic Petit on 7/8/18.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

public struct AdminCredential: Credential {
    public let userId: String
    public var authenticationToken: String?

    func isAuthenticated() -> Bool { return self.authenticationToken != nil }

    func authentication() throws -> String? {
        guard let authenticationToken = self.authenticationToken else {
            throw OMGError.configuration(message: "Authentication token is required")
        }
        return try CredentialEncoder.encode(value1: self.userId, value2: authenticationToken, scheme: "OMGAdmin")
    }

    mutating func update(withAuthenticationToken authenticationToken: AuthenticationToken) {
        self.authenticationToken = authenticationToken.token
    }

    public mutating func invalidate() {
        self.authenticationToken = nil
    }
}
