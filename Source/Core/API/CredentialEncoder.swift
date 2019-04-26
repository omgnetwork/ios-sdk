//
//  CredentialEncoder.swift
//  OmiseGO
//
//  Created by Mederic Petit on 6/8/18.
//  Copyright © 2017-2019 Omise Go Pte. Ltd. All rights reserved.
//

struct CredentialEncoder {
    static func encode(value1: String, value2: String, scheme: String) throws -> String {
        let keys = "\(value1):\(value2)"
        let data = keys.data(using: .utf8, allowLossyConversion: false)

        guard let encodedKey = data?.base64EncodedString() else {
            throw OMGError.configuration(message: "Failed to encode authorization header")
        }

        return "\(scheme) \(encodedKey)"
    }
}
