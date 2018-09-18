//
//  HTTPAdminAPI.swift
//  OmiseGO
//
//  Created by Mederic Petit on 8/8/18.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

public class HTTPAdminAPI: HTTPAPI {
    /// Initialize an http admin api client using a configuration object that can be used to query admin endpoints
    ///
    /// - Parameter config: The AdminConfiguration object
    public init(config: AdminConfiguration) {
        super.init(config: config)
    }
}

extension HTTPAdminAPI {
    /// Login an admin using an email and a password.
    /// Once the request is completed successfully, the current client is automatically
    /// upgraded with the authentication contained in the response.
    /// It can then be used to make other authenticated calls
    ///
    /// - Parameters:
    ///   - params: The login params to use
    ///   - callback: The closure called when the request is completed
    /// - Returns: An optional cancellable request.
    @discardableResult
    public func login(withParams params: LoginParams,
                      callback: @escaping Request<AuthenticationToken>.Callback)
        -> Request<AuthenticationToken>? {
        let request: Request<AuthenticationToken>? = self.request(toEndpoint: APIAdminEndpoint.login(params: params)) { result in
            switch result {
            case let .success(data: authenticationToken):
                self.config.credentials.update(withAuthenticationToken: authenticationToken)
                callback(.success(data: authenticationToken))
            case let .fail(error):
                callback(.fail(error: error))
            }
        }
        return request
    }
}
