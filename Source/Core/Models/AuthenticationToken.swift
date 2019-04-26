//
//  AuthenticationToken.swift
//  OmiseGO
//
//  Created by Mederic Petit on 15/8/18.
//  Copyright © 2017-2019 Omise Go Pte. Ltd. All rights reserved.
//

public struct AuthenticationToken {
    /// The unique authentication token corresponding to the provided credentials
    public let token: String
    /// The user corresponding to the token
    public let user: User
}

extension AuthenticationToken: Decodable {
    private enum CodingKeys: String, CodingKey {
        case token = "authentication_token"
        case user
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        token = try container.decode(String.self, forKey: .token)
        user = try container.decode(User.self, forKey: .user)
    }
}

extension AuthenticationToken: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.token)
    }

    public static func == (lhs: AuthenticationToken, rhs: AuthenticationToken) -> Bool {
        return lhs.token == rhs.token
    }
}
