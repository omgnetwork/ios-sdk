//
//  TransactionExchange.swift
//  OmiseGO
//
//  Created by Mederic Petit on 27/2/18.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

/// Represents a transaction exchange
public struct TransactionExchange: Decodable {

    /// The exchange rate used in the transaction
    public let rate: Double

}
