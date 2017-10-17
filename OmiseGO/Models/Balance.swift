//
//  Balance.swift
//  OmiseGO
//
//  Created by Mederic Petit on 12/10/2560 BE.
//  Copyright © 2560 OmiseGO. All rights reserved.
//

import UIKit

/// Represents a balance of a token
public struct Balance {

    /// The address of the balance
    public let address: String
    /// The symbol of the token
    public let symbol: String
    /// The total amount of token available
    public let amount: Double
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
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        address = try container.decode(String.self, forKey: .address)
        symbol = try container.decode(String.self, forKey: .symbol)
        amount = try container.decode(Double.self, forKey: .amount)
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
