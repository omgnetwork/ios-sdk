//
//  RequestParameters.swift
//  OmiseGO
//
//  Created by Mederic Petit on 20/3/18.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

struct RequestParameters {

    private let config: ClientConfiguration
    private let authScheme = "OMGClient"

    init(config: ClientConfiguration) {
        self.config = config
    }

    func baseURL() -> String {
        return self.config.baseURL
    }

    func encodedAuthorizationHeader() throws -> String {
        guard let authenticationToken = self.config.authenticationToken else {
            throw OMGError.configuration(message: "Please provide an authentication token before using the SDK")
        }
        let keys = "\(self.config.apiKey):\(authenticationToken)"
        let data = keys.data(using: .utf8, allowLossyConversion: false)
        guard let encodedKey = data?.base64EncodedString() else {
            throw OMGError.configuration(message: "bad API key or authentication token (encoding failed.)")
        }

        return "\(authScheme) \(encodedKey)"
    }

    func contentTypeHeader() -> String {
        return "application/vnd.omisego.v\(self.config.apiVersion)+json; charset=utf-8"
    }

    func acceptHeader() -> String {
        return "application/vnd.omisego.v\(self.config.apiVersion)+json"
    }

}
