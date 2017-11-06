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

    /// An array of minted tokens available for the provider
    public let mintedTokens: [MintedToken]

}

extension Setting: Decodable {

    private enum CodingKeys: String, CodingKey {
        case mintedTokens = "minted_tokens"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        mintedTokens = try container.decode([MintedToken].self, forKey: .mintedTokens)
    }

}

extension Setting: Retrievable {

    @discardableResult
    /// Get the global settings of the provider
    ///
    /// - Parameters:
    ///   - client: An optional API client (use the shared client by default).
    ///             This client need to be initialized with a OMGConfiguration struct before being used.
    ///   - callback: The closure called when the request is completed
    /// - Returns: An optional cancellable request.
    public static func get(using client: OMGClient = OMGClient.shared,
                           callback: @escaping Setting.RetrieveRequestCallback) -> Setting.RetrieveRequest? {
        return self.retrieve(using: client, endpoint: .getSettings, callback: callback)
    }

}
