//
//  User+Client.swift
//  OmiseGO
//
//  Created by Mederic Petit on 7/8/2018.
//  Copyright © 2017-2019 Omise Go Pte. Ltd. All rights reserved.
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
    public static func getCurrent(using client: HTTPClientAPI,
                                  callback: @escaping User.RetrieveRequestCallback) -> User.RetrieveRequest? {
        return self.retrieve(using: client, endpoint: APIClientEndpoint.getCurrentUser, callback: callback)
    }

    @discardableResult
    /// Request to reset the user's password
    ///
    /// - Parameters:
    ///   - client: An API client.
    ///             This client need to be initialized with a ClientConfiguration struct before being used.
    ///   - params: The UserResetPasswordParams object to use to perform the request
    ///   - callback: The closure called when the request is completed
    /// - Returns: An optional cancellable request.
    public static func resetPassword(using client: HTTPClientAPI,
                                     params: UserResetPasswordParams,
                                     callback: @escaping Request<EmptyResponse>.Callback) -> Request<EmptyResponse>? {
        let request: Request<EmptyResponse>? =
            client.request(toEndpoint: APIClientEndpoint.resetPassword(params: params), callback: callback)
        return request
    }

    @discardableResult
    /// Update the password of a user given a valid token obtained following a reset password email link
    ///
    /// - Parameters:
    ///   - client: An API client.
    ///             This client need to be initialized with a ClientConfiguration struct before being used.
    ///   - params: The UserUpdatePasswordParams object to use to perform the request
    ///   - callback: The closure called when the request is completed
    /// - Returns: An optional cancellable request.
    public static func updatePassword(using client: HTTPClientAPI,
                                      params: UserUpdatePasswordParams,
                                      callback: @escaping Request<EmptyResponse>.Callback) -> Request<EmptyResponse>? {
        let request: Request<EmptyResponse>? =
            client.request(toEndpoint: APIClientEndpoint.updatePassword(params: params), callback: callback)
        return request
    }
}
