//
//  User.swift
//  OmiseGO
//
//  Created by Mederic Petit on 11/10/2560 BE.
//  Copyright © 2560 OmiseGO. All rights reserved.
//

import UIKit

public struct User {

    // swiftlint:disable:next identifier_name
    public let id: String
    public let providerUserId: String
    public let username: String
    public let metadata: [String: AnyJSONType]

}

extension User: OmiseGOLocatableObject {

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

    public static func getCurrent(using client: APIClient = APIClient.shared,
                                  callback: @escaping User.RetrieveRequestCallback) -> User.RetrieveRequest? {
        return self.retrieve(using: client, callback: callback)
    }

}
