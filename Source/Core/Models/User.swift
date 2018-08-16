//
//  User.swift
//  OmiseGO
//
//  Created by Mederic Petit on 11/10/2017.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

/// Represents a user
public struct User: Listenable {
    /// The unique identifier on the wallet server side
    public let id: String
    /// The user identifier on the provider server side
    public let providerUserId: String
    /// The user's username, it can be an email or any name describing this user
    public let username: String
    /// Any additional metadata that need to be stored as a dictionary
    public let metadata: [String: Any]
    /// Any additional encrypted metadata that need to be stored as a dictionary
    public let encryptedMetadata: [String: Any]
    /// The socket URL from where to receive from
    public let socketTopic: String
    /// The creation date of the user
    public let createdAt: Date
    /// The last update date of the user
    public let updatedAt: Date
}

extension User: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id
        case providerUserId = "provider_user_id"
        case username
        case metadata
        case encryptedMetadata = "encrypted_metadata"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case socketTopic = "socket_topic"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        providerUserId = try container.decode(String.self, forKey: .providerUserId)
        username = try container.decode(String.self, forKey: .username)
        metadata = try container.decode([String: Any].self, forKey: .metadata)
        encryptedMetadata = try container.decode([String: Any].self, forKey: .encryptedMetadata)
        createdAt = try container.decode(Date.self, forKey: .createdAt)
        updatedAt = try container.decode(Date.self, forKey: .updatedAt)
        socketTopic = try container.decode(String.self, forKey: .socketTopic)
    }
}

extension User: Hashable {
    public var hashValue: Int {
        return self.id.hashValue
    }

    public static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
}
