//
//  Wallet.swift
//  OmiseGO
//
//  Created by Thibault Denizet on 12/10/2017.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

/// Represents a wallet containing a list of balances
public struct Wallet: Retrievable, Decodable {

    /// The address of the balances
    public let address: String
    /// The list of balances associated with that address
    public let balances: [Balance]
}

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
        return self.list(using: client, endpoint: .getWallets, callback: callback)
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
        return self.list(using: client, endpoint: .getWallets, callback: { (response) in
            switch response {
            case .success(data: let wallets):
                if wallets.isEmpty {
                    callback(Response.fail(error: OMGError.unexpected(message: "No wallet received.")))
                } else {
                    callback(.success(data: wallets.first!))
                }
            case .fail(error: let error):
                callback(.fail(error: error))
            }

        })
    }

}

extension Wallet: Hashable {

    public var hashValue: Int {
        return self.address.hashValue
    }

    public static func == (lhs: Wallet, rhs: Wallet) -> Bool {
        return lhs.address == rhs.address
    }

}
