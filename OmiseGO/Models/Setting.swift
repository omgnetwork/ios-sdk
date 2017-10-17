//
//  Setting.swift
//  OmiseGO
//
//  Created by Mederic Petit on 12/10/2560 BE.
//  Copyright © 2560 OmiseGO. All rights reserved.
//

import UIKit

/// Represents the global settings of the provider
public struct Setting {

    /// An array of currency tokens available for the provider
    public let tokens: [CurrencyToken]

}

extension Setting: OmiseGOLocatableObject {

    /// The HTTP-RPC operation to get the settings
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

    /// Get the global settings of the provider
    ///
    /// - Parameters:
    ///   - client: An optional API client (use the shared client by default).
    ///             This client need to be initialized with a APIConfiguration struct before being used.
    ///   - callback: The closure called when the request is completed
    /// - Returns: An optional cancellable request.
    public static func get(using client: APIClient = APIClient.shared,
                           callback: @escaping Setting.RetrieveRequestCallback) -> Setting.RetrieveRequest? {
        return self.retrieve(using: client, callback: callback)
    }

}
