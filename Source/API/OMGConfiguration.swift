//
//  OMGConfiguration.swift
//  OmiseGO
//
//  Created by Mederic Petit on 9/10/2017 BE.
//  Copyright © 2017 OmiseGO. All rights reserved.
//

/// Represents a configuration object used to setup an OMGClient
public struct OMGConfiguration {

    /// The current SDK version
    public let apiVersion: String = "1"

    /// The base URL of the wallet server
    public let baseURL: String
    /// The API key provided by OmiseGO
    public let apiKey: String
    /// The authentication token of the current user
    public var authenticationToken: String?

    public init(baseURL: String, apiKey: String, authenticationToken: String) {
        self.baseURL = baseURL
        self.apiKey = apiKey
        self.authenticationToken = authenticationToken
    }

}
