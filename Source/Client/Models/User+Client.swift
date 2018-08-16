//
//  User+Client.swift
//  OmiseGO
//
//  Created by Mederic Petit on 7/8/2018.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

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
        return self.retrieve(using: client, endpoint: APIClientEndpoint.getCurrentUser, callback: callback)
    }
}
