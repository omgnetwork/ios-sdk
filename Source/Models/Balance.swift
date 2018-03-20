//
//  Balance.swift
//  OmiseGO
//
//  Created by Mederic Petit on 12/10/2017.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

/// Represents a balance of a minted token
public struct Balance: Decodable {

    /// The minted token corresponding to the balance
    public let mintedToken: MintedToken
    /// The total amount of minted token available
    public let amount: Double

    private enum CodingKeys: String, CodingKey {
        case mintedToken = "minted_token"
        case amount
    }
}

extension Balance {

    /// Helper method that returns an easily readable value of the amount
    ///
    /// - Parameter precision: The decimal precision to give to the formatter
    /// for example a number 0.123 with a precision of 1 will be 0.1
    /// - Returns: the formatted balance amount
    public func displayAmount(withPrecision precision: Int = 1000) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = precision
        let displayableAmount: Double = self.amount / self.mintedToken.subUnitToUnit
        let formattedDisplayAmount = formatter.string(from: NSNumber(value: displayableAmount))
        return formattedDisplayAmount ?? ""
    }

}

extension Balance: Hashable {

    public var hashValue: Int {
        return self.mintedToken.hashValue ^ self.amount.hashValue
    }

}

// MARK: Equatable

public func == (lhs: Balance, rhs: Balance) -> Bool {
    return lhs.mintedToken == rhs.mintedToken && lhs.amount == rhs.amount
}
