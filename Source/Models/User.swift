//
//  User.swift
//  OmiseGO
//
//  Created by Mederic Petit on 11/10/2017.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

/// Represents the current user
public struct User: Listenable {

    /// The unique identifier on the wallet server side
    public let id: String
    /// The user identifier on the provider server side
    public let providerUserId: String
    /// The user's username, it can be an email or any name describing this user
    public let username: String
    /// Any additional metadata that need to be stored as a dictionary
    public let metadata: [String: Any]
    /// The socket URL from where to receive from
    public let socketTopic: String

}

extension User: Decodable {

    private enum CodingKeys: String, CodingKey {
        case id
        case providerUserId = "provider_user_id"
        case username
        case metadata
        case socketTopic = "socket_topic"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        providerUserId = try container.decode(String.self, forKey: .providerUserId)
        username = try container.decode(String.self, forKey: .username)
        do {metadata = try container.decode([String: Any].self, forKey: .metadata)} catch {metadata = [:]}
        socketTopic = try container.decode(String.self, forKey: .socketTopic)
    }

}

extension User: Retrievable {

    @discardableResult
    /// Get the current user corresponding to the authentication token provided in the configuration
    ///
    /// - Parameters:
    ///   - client: An API client.
    ///             This client need to be initialized with a ClientConfiguration struct before being used.
    ///   - callback: The closure called when the request is completed
    /// - Returns: An optional cancellable request.
    public static func getCurrent(using client: HTTPClient,
                                  callback: @escaping User.RetrieveRequestCallback) -> User.RetrieveRequest? {
        return self.retrieve(using: client, endpoint: .getCurrentUser, callback: callback)
    }

}

extension User: Hashable {

    public var hashValue: Int {
        return self.id.hashValue
    }

    public static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }

}
