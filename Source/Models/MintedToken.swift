//
//  MintedToken.swift
//  OmiseGO
//
//  Created by Mederic Petit on 12/10/2017 BE.
//  Copyright © 2017 OmiseGO. All rights reserved.
//

/// Represents a minted token
public struct MintedToken: Decodable {

    /// The id of the minted token
    public let id: String
    /// The symbol of the minted token
    public let symbol: String
    /// The full name of the minted token
    public let name: String
    /// The multiplier representing the value of 1 minted token. i.e: if I want to give or receive
    /// 13 minted tokens and the subunitToUnit is 1000 then the amount will be 13*1000 = 13000
    public let subUnitToUnit: Double

    private enum CodingKeys: String, CodingKey {
        case id
        case symbol
        case name
        case subUnitToUnit = "subunit_to_unit"
    }

}

extension MintedToken: Hashable {

    public var hashValue: Int {
        return self.id.hashValue
    }

}

// MARK: Equatable

public func == (lhs: MintedToken, rhs: MintedToken) -> Bool {
    return lhs.id == rhs.id
}
