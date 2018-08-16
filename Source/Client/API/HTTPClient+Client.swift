//
//  HTTPClient+Client.swift
//  OmiseGO
//
//  Created by Mederic Petit on 7/8/18.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

extension HTTPClient {
    /// Initialize an http client using a configuration object that can be used to query client endpoints
    ///
    /// - Parameter config: The ClientConfiguration object
    public convenience init(config: ClientConfiguration) {
        self.init()
        self.config = config
    }

    /// Logout the current user (invalidate the provided authenticationToken).
    ///
    /// - Parameter callback: The closure called when the request is completed
    /// - Returns: An optional cancellable request.
    @discardableResult
    public func logoutClient(withCallback callback: @escaping Request<EmptyResponse>.Callback)
        -> Request<EmptyResponse>? {
        let request: Request<EmptyResponse>? = self.request(toEndpoint: APIClientEndpoint.logout) { result in
            switch result {
            case let .success(data: data):
                self.config.credentials.invalidate()
                callback(.success(data: data))
            case let .fail(error):
                callback(.fail(error: error))
            }
        }
        return request
    }
}
