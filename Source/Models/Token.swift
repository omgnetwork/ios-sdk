//
//  Token.swift
//  OmiseGO
//
//  Created by Mederic Petit on 12/10/2017.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

import BigInt

/// Represents a token
public struct Token {
    /// The id of the token
    public let id: String
    /// The symbol of the token
    public let symbol: String
    /// The full name of the token
    public let name: String
    /// The multiplier representing the value of 1 token. i.e: if I want to give or receive
    /// 13 tokens and the subunitToUnit is 1000 then the amount will be 13*1000 = 13000
    public let subUnitToUnit: BigInt
    /// Any additional metadata that need to be stored as a dictionary
    public let metadata: [String: Any]
    /// Any additional encrypted metadata that need to be stored as a dictionary
    public let encryptedMetadata: [String: Any]
    /// The creation date of the token
    public let createdAt: Date
    /// The last update date of the token
    public let updatedAt: Date
}

extension Token: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id
        case symbol
        case name
        case subUnitToUnit = "subunit_to_unit"
        case metadata
        case encryptedMetadata = "encrypted_metadata"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        symbol = try container.decode(String.self, forKey: .symbol)
        name = try container.decode(String.self, forKey: .name)
        subUnitToUnit = try container.decode(BigInt.self, forKey: .subUnitToUnit)
        metadata = try container.decode([String: Any].self, forKey: .metadata)
        encryptedMetadata = try container.decode([String: Any].self, forKey: .encryptedMetadata)
        createdAt = try container.decode(Date.self, forKey: .createdAt)
        updatedAt = try container.decode(Date.self, forKey: .updatedAt)
    }
}

extension Token: Hashable {
    public var hashValue: Int {
        return self.id.hashValue
    }

    public static func == (lhs: Token, rhs: Token) -> Bool {
        return lhs.id == rhs.id
    }
}
