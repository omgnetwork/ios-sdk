//
//  TransactionSource.swift
//  OmiseGO
//
//  Created by Mederic Petit on 27/2/18.
//  Copyright © 2018 OmiseGO. All rights reserved.
//

/// Represents a transaction source contained in a transaction object
public struct TransactionSource: Decodable {

    public let address: String
    public let amount: Double
    public let mintedToken: MintedToken

    private enum CodingKeys: String, CodingKey {
        case address
        case amount
        case mintedToken = "minted_token"
    }

}
