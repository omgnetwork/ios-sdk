//
//  Wallet+Admin.swift
//  OmiseGO
//
//  Created by Mederic Petit on 17/9/18.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

extension Wallet {
    @discardableResult
    /// Get a wallet from its address
    ///
    /// - Parameters:
    ///   - client: An API client.
    ///             This client need to be initialized with a ClientConfiguration struct before being used.
    ///   - params: The WalletGetParams object containing the address of the wallet to retrieve
    ///   - callback: The closure called when the request is completed
    /// - Returns: An optional cancellable request.
    public static func get(using client: HTTPAdminAPI,
                           params: WalletGetParams,
                           callback: @escaping Wallet.RetrieveRequestCallback) -> Wallet.RetrieveRequest? {
        return self.retrieve(using: client, endpoint: APIAdminEndpoint.getWallet(params: params), callback: callback)
    }
}
