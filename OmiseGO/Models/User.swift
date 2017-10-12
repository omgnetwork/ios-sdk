//
//  User.swift
//  OmiseGO
//
//  Created by Mederic Petit on 11/10/2560 BE.
//  Copyright © 2560 OmiseGO. All rights reserved.
//

import UIKit

public struct User: OmiseGOLocatableObject {

    public static let operation: String = "user.me"

    public let object: String
    // swiftlint:disable:next identifier_name
    public let id: String
    public let providerUserId: String
    public let username: String
    public let metadata: [String: AnyJSONType]

}

extension User: Decodable {

    private enum CodingKeys: String, CodingKey {
        case object
        // swiftlint:disable:next identifier_name
        case id
        case providerUserId = "provider_user_id"
        case username
        case metadata
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        object = try container.decode(String.self, forKey: .object)
        id = try container.decode(String.self, forKey: .id)
        providerUserId = try container.decode(String.self, forKey: .providerUserId)
        username = try container.decode(String.self, forKey: .username)
        metadata = try container.decode([String: AnyJSONType].self, forKey: .metadata)
    }

}

extension User: Retrievable {

    public static func getCurrent(using client: APIClient = APIClient.shared,
                                  callback: @escaping User.RetrieveRequest.Callback) -> User.RetrieveRequest? {
        return self.retrieve(using: client, callback: callback)
    }

}
