//
//  User.swift
//  OmiseGO
//
//  Created by Mederic Petit on 11/10/2560 BE.
//  Copyright © 2560 OmiseGO. All rights reserved.
//

import UIKit

/// Represents the current user
public struct User {

    // swiftlint:disable identifier_name
    /// The uniq identifier on the wallet server side
    public let id: String
    /// The user identifier on the provider server side
    public let providerUserId: String
    /// The user's username, it can be an email or any name describing this user
    public let username: String
    /// Any additional metadata that need to be stored as a dictionary
    public let metadata: [String: AnyJSONType]

}

extension User: OmiseGOLocatableObject {

    /// The HTTP-RPC operation to get the current user
    public static let operation: String = "user.me"

}

extension User: Decodable {

    private enum CodingKeys: String, CodingKey {
        // swiftlint:disable:next identifier_name
        case id
        case providerUserId = "provider_user_id"
        case username
        case metadata
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        providerUserId = try container.decode(String.self, forKey: .providerUserId)
        username = try container.decode(String.self, forKey: .username)
        metadata = try container.decode([String: AnyJSONType].self, forKey: .metadata)
    }

}

extension User: Retrievable {

    @discardableResult
    /// Get the current user corresponding to the authentication token provided in the configuration
    ///
    /// - Parameters:
    ///   - client: An optional API client (use the shared client by default).
    ///             This client need to be initialized with a APIConfiguration struct before being used.
    ///   - callback: The closure called when the request is completed
    /// - Returns: An optional cancellable request.
    public static func getCurrent(using client: APIClient = APIClient.shared,
                                  callback: @escaping User.RetrieveRequestCallback) -> User.RetrieveRequest? {
        return self.retrieve(using: client, callback: callback)
    }

}
