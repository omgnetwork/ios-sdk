//
//  Setting.swift
//  OmiseGO
//
//  Created by Mederic Petit on 12/10/2560 BE.
//  Copyright © 2560 OmiseGO. All rights reserved.
//

import UIKit

public struct Setting {

    public let tokens: [CurrencyToken]

}

extension Setting: OmiseGOLocatableObject {

    public static let operation: String = "me.get_settings"

}

extension Setting: Decodable {

    private enum CodingKeys: String, CodingKey {
        case tokens
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        tokens = try container.decode([CurrencyToken].self, forKey: .tokens)
    }

}

extension Setting: Retrievable {

    public static func get(using client: APIClient = APIClient.shared,
                           callback: @escaping Setting.RetrieveRequestCallback) -> Setting.RetrieveRequest? {
        return self.retrieve(using: client, callback: callback)
    }

}
