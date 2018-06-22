//
//  TransactionSource.swift
//  OmiseGO
//
//  Created by Mederic Petit on 27/2/18.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

import BigInt

/// Represents a transaction source contained in a transaction object
public struct TransactionSource {

    /// The address of the source
    public let address: String
    /// The amount of token (down to subunit to unit)
    public let amount: BigInt
    /// The token of the source
    public let token: Token

}

extension TransactionSource: Decodable {

    private enum CodingKeys: String, CodingKey {
        case address
        case amount
        case token
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        address = try container.decode(String.self, forKey: .address)
        amount = try container.decode(BigInt.self, forKey: .amount)
        token = try container.decode(Token.self, forKey: .token)
    }
}
