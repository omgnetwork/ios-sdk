//
//  ClientCredential.swift
//  OmiseGO
//
//  Created by Mederic Petit on 7/8/18.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

/// Represents the credentials needed for making client API calls.
/// They consist on an API key and an authentication token.
public struct ClientCredential: Credential {
    public let apiKey: String
    public var authenticationToken: String?

    /// Initialize a ClientCredential with the given API key and authentication token
    ///
    /// - Parameters:
    ///   - apiKey: The API key to use for the authenticated calls
    ///   - authenticationToken: The authentication token of the user
    public init(apiKey: String, authenticationToken: String) {
        self.apiKey = apiKey
        self.authenticationToken = authenticationToken
    }

    func authentication() throws -> String? {
        guard let authenticationToken = self.authenticationToken else {
            throw OMGError.configuration(message: "Authentication token is required")
        }
        return try CredentialEncoder.encode(value1: self.apiKey, value2: authenticationToken, scheme: "OMGClient")
    }

    public mutating func invalidate() {
        self.authenticationToken = nil
    }
}
