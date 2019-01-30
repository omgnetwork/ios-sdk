//
//  HTTPClientAPI.swift
//  OmiseGO
//
//  Created by Mederic Petit on 7/8/18.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

public class HTTPClientAPI: HTTPAPI {
    /// Initialize an http client using a configuration object that can be used to query client endpoints
    ///
    /// - Parameter config: The ClientConfiguration object
    public init(config: ClientConfiguration) {
        super.init(config: config)
    }
}

extension HTTPClientAPI {
    /// Logout the current user (invalidate the provided authenticationToken).
    ///
    /// - Parameter callback: The closure called when the request is completed
    /// - Returns: An optional cancellable request.
    @discardableResult
    public func logout(withCallback callback: @escaping Request<EmptyResponse>.Callback)
        -> Request<EmptyResponse>? {
        let request: Request<EmptyResponse>? = self.request(toEndpoint: APIClientEndpoint.logout) { [weak self] result in
            guard let self = self else { return }
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

    /// Login a user using an email and a password.
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
        let request: Request<AuthenticationToken>? =
            self.request(toEndpoint: APIClientEndpoint.login(params: params)) { [weak self] result in
                guard let self = self else { return }
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

    /// Signup a new user using the provided params.
    ///
    /// - Parameters:
    ///   - params: The signup params to use
    ///   - callback: The closure called when the request is completed
    /// - Returns: An optional cancellable request.
    @discardableResult
    public func signup(withParams params: SignupParams,
                       callback: @escaping Request<EmptyResponse>.Callback)
        -> Request<EmptyResponse>? {
        let request: Request<EmptyResponse>? = self.request(toEndpoint: APIClientEndpoint.signup(params: params)) { result in
            switch result {
            case let .success(data: data):
                callback(.success(data: data))
            case let .fail(error):
                callback(.fail(error: error))
            }
        }
        return request
    }
}
