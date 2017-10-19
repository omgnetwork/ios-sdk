//
//  Balance.swift
//  OmiseGO
//
//  Created by Mederic Petit on 12/10/2560 BE.
//  Copyright © 2560 OmiseGO. All rights reserved.
//

import UIKit

/// Represents a balance of a minted token
public struct Balance {

    /// The address of the balance
    public let address: String
    /// The symbol of the minted token
    public let symbol: String
    /// The total amount of minted token available
    public let amount: Double
    /// The multiplier representing the value of 1 minted token. i.e: if I want to give or receive
    /// 13 minted tokens and the subunitToUnit is 1000 then the amount will be 13*1000 = 13000
    public let subUnitToUnit: Double
}

extension Balance {

    func displayAmount() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1000
        let displayableAmount: Double = self.amount / self.subUnitToUnit
        let formattedDisplayAmount = formatter.string(from: NSNumber(value: displayableAmount))
        return formattedDisplayAmount ?? ""
    }

}

extension Balance: OmiseGOListableObject {

    /// The HTTP-RPC operation to get the balances of the current user
    public static let listOperation: String = "me.list_balances"

}

extension Balance: Decodable {

    private enum CodingKeys: String, CodingKey {
        case address
        case symbol
        case amount
        case subUnitToUnit = "subunit_to_unit"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        address = try container.decode(String.self, forKey: .address)
        symbol = try container.decode(String.self, forKey: .symbol)
        amount = try container.decode(Double.self, forKey: .amount)
        subUnitToUnit = try container.decode(Double.self, forKey: .subUnitToUnit)
    }

}

extension Balance: Listable {

    @discardableResult
    /// Get all balances of the current user
    ///
    /// - Parameters:
    ///   - client: An optional API client (use the shared client by default).
    ///             This client need to be initialized with a APIConfiguration struct before being used.
    ///   - callback: The closure called when the request is completed
    /// - Returns: An optional cancellable request.
    public static func getAll(using client: APIClient = APIClient.shared,
                              callback: @escaping Balance.ListRequestCallback) -> Balance.ListRequest? {
        return self.list(using: client, callback: callback)
    }

}
