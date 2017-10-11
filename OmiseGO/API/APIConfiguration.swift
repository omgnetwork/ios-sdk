//
//  APIConfiguration.swift
//  OmiseGO
//
//  Created by Mederic Petit on 9/10/2560 BE.
//  Copyright © 2560 OmiseGO. All rights reserved.
//

import Foundation

public struct APIConfiguration {

    public let apiVersion: String = "1.0.0"

    public let baseURL: String
    public let apiKey: String
    public let authenticationToken: String

    public init(baseURL: String, apiKey: String, authenticationToken: String) {
        self.baseURL = baseURL
        self.apiKey = apiKey
        self.authenticationToken = authenticationToken
    }

}
