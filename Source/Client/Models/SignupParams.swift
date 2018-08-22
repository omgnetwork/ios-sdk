//
//  SignupParams.swift
//  OmiseGO
//
//  Created by Mederic Petit on 22/8/18.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

/// Represents a structure used to signup a new user
public struct SignupParams {
    /// The email to use for signup
    public let email: String
    /// The password to use for signup
    public let password: String
    /// The password confirmation that should match the password
    public let passwordConfirmation: String
    /// An optional redirect URL if you want to use an other page from the default one
    public let redirectURL: String?
    /// An optional success URL to redirect the user to upon successful verification
    public let successURL: String?

    /// Initialize the params used to signup a user
    ///
    /// - Parameters:
    ///   - email: The email of the user
    ///   - password: The password of the user
    ///   - passwordConfirmation: The password confirmation that should match the password
    ///   - redirectURL: An optional redirect URL if you want to use an other page from the default one
    ///   - successURL: An optional success URL to redirect the user to upon successful verification
    public init(email: String,
                password: String,
                passwordConfirmation: String,
                redirectURL: String? = nil,
                successURL: String? = nil) {
        self.email = email
        self.password = password
        self.passwordConfirmation = passwordConfirmation
        self.redirectURL = redirectURL
        self.successURL = successURL
    }
}

extension SignupParams: APIParameters {
    private enum CodingKeys: String, CodingKey {
        case email
        case password
        case passwordConfirmation = "password_confirmation"
        case redirectURL = "redirect_url"
        case successURL = "success_url"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(email, forKey: .email)
        try container.encode(password, forKey: .password)
        try container.encode(passwordConfirmation, forKey: .passwordConfirmation)
        try container.encodeIfPresent(redirectURL, forKey: .redirectURL)
        try container.encodeIfPresent(successURL, forKey: .successURL)
    }
}
