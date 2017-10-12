//
//  Balance.swift
//  OmiseGO
//
//  Created by Mederic Petit on 12/10/2560 BE.
//  Copyright © 2560 OmiseGO. All rights reserved.
//

import UIKit

public struct Balance: OmiseGOLocatableObject {

    public static let operation: String = "me.list_balances"

    public let object: String
    public let address: String
    public let symbol: String
    public let amount: Double
}

extension Balance: Decodable {

    private enum CodingKeys: String, CodingKey {
        case object
        case address
        case symbol
        case amount
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        object = try container.decode(String.self, forKey: .object)
        address = try container.decode(String.self, forKey: .address)
        symbol = try container.decode(String.self, forKey: .symbol)
        amount = try container.decode(Double.self, forKey: .amount)
    }

}

extension Balance: Listable {

    public static func getAll(using client: APIClient = APIClient.shared,
                              callback: @escaping Balance.ListRequest.Callback) -> Balance.ListRequest? {
        return self.list(using: client, callback: callback)
    }

}
