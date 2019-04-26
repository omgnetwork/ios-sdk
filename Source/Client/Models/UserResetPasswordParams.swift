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
    /// The URL of the link that the user will receive by email.
    /// In most cases this should be the default URL, only override if you
    /// are building your custom system
    public let resetPasswordURL: String
    /// The default reset password page will try to redirect the user to this forwardURL if present.
    /// If omitted or invalid, the user will be able to reset his password on the default page.
    /// You can use this URL if you want the default page to open your app with it's scheme for example.
    public let forwardURL: String?

    static let defaultResetPasswordPath = "/client/reset_password?email={email}&token={token}"

    /// Initialize the params used to request a password reset for the user
    ///
    /// - Parameters:
    ///   - email: The email of the user
    ///   - resetPasswordURL: The URL of the link that the user will receive by email.
    /// In most cases, you'll want to use the URL from defaultResetPasswordURL(forClient:)
    ///   - forwardURL: The default reset password page will try to redirect the user to this forwardURL if present.
    /// If omitted or invalid, the user will be able to reset his password on the default page.
    /// You can use this URL if you want the default page to open your app with it's scheme for example.
    public init(email: String,
                resetPasswordURL: String,
                forwardURL: String? = nil) {
        self.email = email
        self.resetPasswordURL = resetPasswordURL
        self.forwardURL = forwardURL
    }

    public static func defaultResetPasswordURL(forClient client: HTTPClientAPI) -> String {
        return client.config.baseURL + self.defaultResetPasswordPath
    }
}

extension UserResetPasswordParams: APIParameters {
    private enum CodingKeys: String, CodingKey {
        case email
        case resetPasswordURL = "reset_password_url"
        case forwardURL = "forward_url"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(email, forKey: .email)
        try container.encode(resetPasswordURL, forKey: .resetPasswordURL)
        try container.encodeIfPresent(forwardURL, forKey: .forwardURL)
    }
}
