//
//  UserResetPasswordParams.swift
//  OmiseGO
//
//  Created by Mederic Petit on 14/3/19.
//  Copyright © 2019 Omise Go Pte. Ltd. All rights reserved.
//

/// Represents a structure used to request a password reset for the user
public struct UserResetPasswordParams {
    /// The email of the user
    public let email: String
    /// The URL where the user will be taken when clicking the link in the email
    public let redirectUrl: String

    /// Initialize the params used to request a password reset for the user
    ///
    /// - Parameters:
    ///   - email: The email of the user
    ///   - redirectUrl: The URL where the user will be taken when clicking the link in the email
    public init(email: String,
                redirectUrl: String) {
        self.email = email
        self.redirectUrl = redirectUrl
    }
}

extension UserResetPasswordParams: APIParameters {
    private enum CodingKeys: String, CodingKey {
        case email
        case redirectUrl = "redirect_url"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(email, forKey: .email)
        try container.encode(redirectUrl, forKey: .redirectUrl)
    }
}
