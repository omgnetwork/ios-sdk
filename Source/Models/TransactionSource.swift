//
//  TransactionSource.swift
//  OmiseGO
//
//  Created by Mederic Petit on 27/2/18.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

/// Represents a transaction source contained in a transaction object
public struct TransactionSource: Decodable {

    /// The address of the source
    public let address: String
    /// The amount of token (down to subunit to unit)
    public let amount: Double
    /// The token of the source
    public let token: Token

}
