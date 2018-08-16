//
//  Wallet+Client.swift
//  OmiseGO
//
//  Created by Mederic Petit on 7/8/2018.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

extension Wallet: Listable {
    @discardableResult
    /// Get all wallets of the current user
    ///
    /// - Parameters:
    ///   - client: An API client.
    ///             This client need to be initialized with a ClientConfiguration struct before being used.
    ///   - callback: The closure called when the request is completed
    /// - Returns: An optional cancellable request.
    public static func getAll(using client: HTTPClient,
                              callback: @escaping Wallet.ListRequestCallback) -> Wallet.ListRequest? {
        return self.list(using: client, endpoint: APIClientEndpoint.getWallets, callback: callback)
    }

    @discardableResult
    /// Get the main wallet for the current user
    ///
    /// - Parameters:
    ///   - client: An API client.
    ///             This client need to be initialized with a ClientConfiguration struct before being used.
    ///   - callback: The closure called when the request is completed
    /// - Returns: An optional cancellable request.
    public static func getMain(using client: HTTPClient,
                               callback: @escaping Wallet.RetrieveRequestCallback) -> Wallet.ListRequest? {
        return self.list(using: client, endpoint: APIClientEndpoint.getWallets, callback: { response in
            switch response {
            case let .success(data: wallets):
                if wallets.isEmpty {
                    callback(Response.fail(error: OMGError.unexpected(message: "No wallet received.")))
                } else {
                    callback(.success(data: wallets.first!))
                }
            case let .fail(error: error):
                callback(.fail(error: error))
            }

        })
    }
}
