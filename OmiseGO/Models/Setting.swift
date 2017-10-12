//
//  Setting.swift
//  OmiseGO
//
//  Created by Mederic Petit on 12/10/2560 BE.
//  Copyright © 2560 OmiseGO. All rights reserved.
//

import UIKit

public struct Setting: OmiseGOLocatableObject {

    public static let operation: String = "me.get_settings"

    public let object: String
    public let tokens: [CurrencyToken]

}

extension Setting: Decodable {

    private enum CodingKeys: String, CodingKey {
        case object
        case tokens
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        object = try container.decode(String.self, forKey: .object)
        tokens = try container.decode([CurrencyToken].self, forKey: .tokens)
    }

}

extension Setting: Retrievable {

    public static func get(using client: APIClient = APIClient.shared,
                           callback: @escaping Setting.RetrieveRequest.Callback) -> Setting.RetrieveRequest? {
        return self.retrieve(using: client, callback: callback)
    }

}
