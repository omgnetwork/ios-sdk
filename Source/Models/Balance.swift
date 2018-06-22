//
//  Balance.swift
//  OmiseGO
//
//  Created by Mederic Petit on 12/10/2017.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

import BigInt

/// Represents a balance of a token
public struct Balance: Decodable {

    /// The token corresponding to the balance
    public let token: Token
    /// The total amount of token available
    public let amount: BigInt

}

extension Balance {

    /// Helper method that returns an easily readable value of the amount
    ///
    /// - Parameter precision: The decimal precision to give to the formatter
    /// for example a number 0.123 with a precision of 1 will be 0.1
    /// - Returns: the formatted balance amount
    public func displayAmount(withPrecision precision: Int = 1000) -> String {
        return OMGNumberFormatter(precision: precision).string(from: self.amount, subunitToUnit: self.token.subUnitToUnit)
    }

}

extension Balance: Hashable {

    public var hashValue: Int {
        return self.token.hashValue ^ self.amount.hashValue
    }

    public static func == (lhs: Balance, rhs: Balance) -> Bool {
        return lhs.token == rhs.token && lhs.amount == rhs.amount
    }

}
