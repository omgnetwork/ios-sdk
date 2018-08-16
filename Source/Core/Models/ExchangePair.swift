//
//  ExchangePair.swift
//  OmiseGO
//
//  Created by Mederic Petit on 29/6/18.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

import UIKit

/// An ExchangePair describes 2 tradable tokens with a specific rate
public struct ExchangePair {
    /// The unique identifier of the exchange pair
    public let id: String
    /// The name of the pair (ex: ETH/BTC)
    public let name: String
    /// The 1st token id of the pair
    public let fromTokenId: String
    /// The 1st token of the pair
    public let fromToken: Token
    /// The 2nd token id of the pair
    public let toTokenId: String
    /// The 2nd token of the pair
    public let toToken: Token
    /// The rate between both tokens (token2/token1)
    public let rate: Double
    /// The creation date of the pair
    public let createdAt: Date
    /// The last update date of the pair
    public let updatedAt: Date
}

extension ExchangePair: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case fromTokenId = "from_token_id"
        case fromToken = "from_token"
        case toTokenId = "to_token_id"
        case toToken = "to_token"
        case rate
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        fromTokenId = try container.decode(String.self, forKey: .fromTokenId)
        fromToken = try container.decode(Token.self, forKey: .fromToken)
        toTokenId = try container.decode(String.self, forKey: .toTokenId)
        toToken = try container.decode(Token.self, forKey: .toToken)
        rate = try container.decode(Double.self, forKey: .rate)
        createdAt = try container.decode(Date.self, forKey: .createdAt)
        updatedAt = try container.decode(Date.self, forKey: .updatedAt)
    }
}

extension ExchangePair: Hashable {
    public var hashValue: Int {
        return self.id.hashValue
    }

    public static func == (lhs: ExchangePair, rhs: ExchangePair) -> Bool {
        return lhs.id == rhs.id
    }
}
