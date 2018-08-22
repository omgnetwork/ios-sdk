//
//  Setting+Client.swift
//  OmiseGO
//
//  Created by Mederic Petit on 7/8/2018.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

extension Setting: Retrievable {
    @discardableResult
    /// Get the global settings of the provider
    ///
    /// - Parameters:
    ///   - client: An API client.
    ///             This client need to be initialized with a ClientConfiguration struct before being used.
    ///   - callback: The closure called when the request is completed
    /// - Returns: An optional cancellable request.
    public static func get(using client: HTTPClientAPI,
                           callback: @escaping Setting.RetrieveRequestCallback) -> Setting.RetrieveRequest? {
        return self.retrieve(using: client, endpoint: APIClientEndpoint.getSettings, callback: callback)
    }
}
