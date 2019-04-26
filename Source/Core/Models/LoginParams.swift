//
//  LoginParams.swift
//  OmiseGO
//
//  Created by Mederic Petit on 15/8/18.
//  Copyright © 2017-2019 Omise Go Pte. Ltd. All rights reserved.
//

/// Represents a structure used to login an existing user
public struct LoginParams {
    public let email: String
    public let password: String

    /// Initialize the params used to login a user
    ///
    /// - Parameters:
    ///   - email: The email of the user
    ///   - password: The password of the user
    public init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}

extension LoginParams: APIParameters {
    private enum CodingKeys: String, CodingKey {
        case email
        case password
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(email, forKey: .email)
        try container.encode(password, forKey: .password)
    }
}
