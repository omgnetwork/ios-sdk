//
//  CurrencyToken.swift
//  OmiseGO
//
//  Created by Mederic Petit on 12/10/2560 BE.
//  Copyright © 2560 OmiseGO. All rights reserved.
//

import UIKit

public struct CurrencyToken: OmiseGOObject {

    public let symbol: String
    public let name: String

}

extension CurrencyToken: Decodable {

    private enum CodingKeys: String, CodingKey {
        case symbol
        case name
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        symbol = try container.decode(String.self, forKey: .symbol)
        name = try container.decode(String.self, forKey: .name)
    }

}
