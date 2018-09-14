//
//  Account.swift
//  OmiseGO
//
//  Created by Mederic Petit on 18/4/18.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

/// Represents an account
public struct Account {
    /// The unique identifier of the account
    public let id: String
    /// The id of the parent account
    public let parentId: String?
    /// The name of the account
    public let name: String
    /// The description of the account
    public let description: String?
    /// A boolean indicating if the account is a master account or not
    public let isMaster: Bool
    /// The avatar object containing urls
    public let avatar: Avatar
    /// Any additional metadata that need to be stored as a dictionary
    public let metadata: [String: Any]
    /// Any additional encrypted metadata that need to be stored as a dictionary
    public let encryptedMetadata: [String: Any]
    /// The creation date of the account
    public let createdAt: Date
    /// The date when the account was last updated
    public let updatedAt: Date
}

extension Account: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id
        case parentId = "parent_id"
        case name
        case description
        case isMaster = "master"
        case avatar
        case metadata
        case encryptedMetadata = "encrypted_metadata"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        parentId = try container.decodeIfPresent(String.self, forKey: .parentId)
        name = try container.decode(String.self, forKey: .name)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        isMaster = try container.decode(Bool.self, forKey: .isMaster)
        avatar = try container.decode(Avatar.self, forKey: .avatar)
        metadata = try container.decode([String: Any].self, forKey: .metadata)
        encryptedMetadata = try container.decode([String: Any].self, forKey: .encryptedMetadata)
        createdAt = try container.decode(Date.self, forKey: .createdAt)
        updatedAt = try container.decode(Date.self, forKey: .updatedAt)
    }
}

extension Account: Hashable {
    public var hashValue: Int {
        return self.id.hashValue
    }

    public static func == (lhs: Account, rhs: Account) -> Bool {
        return lhs.id == rhs.id
    }
}
