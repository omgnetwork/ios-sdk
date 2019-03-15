//
//  UserUpdatePasswordParams.swift
//  OmiseGO
//
//  Created by Mederic Petit on 14/3/19.
//  Copyright © 2019 Omise Go Pte. Ltd. All rights reserved.
//

/// Represents a structure used to update the password of a user following a reset
public struct UserUpdatePasswordParams {
    /// The email of the user (obtained from the params in the link sent to the email of the user)
    public let email: String
    /// The unique reset password token obtained from the params in the link sent to the email of the user
    public let token: String?
    /// The updated password
    public let password: String
    /// The password confirmation that should match the updated password
    public let passwordConfirmation: String

    /// Initialize the params used to signup a user
    ///
    /// - Parameters:
    ///   - email: The email of the user (obtained from the params in the link sent to the email of the user)
    ///   - token: The unique reset password token obtained from the params in the link sent to the email of the user
    ///   - password: The updated password
    ///   - passwordConfirmation: The password confirmation that should match the updated password
    public init(email: String,
                token: String,
                password: String,
                passwordConfirmation: String) {
        self.email = email
        self.token = token
        self.password = password
        self.passwordConfirmation = passwordConfirmation
    }
}

extension UserUpdatePasswordParams: APIParameters {
    private enum CodingKeys: String, CodingKey {
        case email
        case token
        case password
        case passwordConfirmation = "password_confirmation"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(email, forKey: .email)
        try container.encode(token, forKey: .token)
        try container.encode(password, forKey: .password)
        try container.encode(passwordConfirmation, forKey: .passwordConfirmation)
    }
}
