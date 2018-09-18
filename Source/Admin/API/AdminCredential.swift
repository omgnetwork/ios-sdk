//
//  AdminCredential.swift
//  OmiseGO
//
//  Created by Mederic Petit on 7/8/18.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

public struct AdminCredential: Credential {
    public var userId: String?
    public var authenticationToken: String?

    /// Initialize an AdminCredential object with the given userId and authentication token
    ///
    /// - Parameters:
    ///   - userId: The userId of the admin to use for the authenticated calls. Can be nil if doing request that don't need authentication.
    ///   - authenticationToken: The authentication token of the admin. Can be nil if doing request that don't need authentication.
    public init(userId: String, authenticationToken: String) {
        self.userId = userId
        self.authenticationToken = authenticationToken
    }

    public init() {}

    func isAuthenticated() -> Bool { return self.authenticationToken != nil && self.userId != nil }

    func authentication() throws -> String? {
        guard let authenticationToken = self.authenticationToken, let userId = self.userId else {
            return nil
        }
        return try CredentialEncoder.encode(value1: userId, value2: authenticationToken, scheme: "OMGAdmin")
    }

    mutating func update(withAuthenticationToken authenticationToken: AuthenticationToken) {
        self.userId = authenticationToken.user.id
        self.authenticationToken = authenticationToken.token
    }

    public mutating func invalidate() {
        self.authenticationToken = nil
    }
}
