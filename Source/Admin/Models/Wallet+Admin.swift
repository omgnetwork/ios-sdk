//
//  Wallet+Admin.swift
//  OmiseGO
//
//  Created by Mederic Petit on 17/9/18.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

extension Wallet: Searchable {
    public enum SearchableFields: String, KeyEncodable {
        case address
        case name
        case identifier
    }
}

extension Wallet: Sortable {
    public enum SortableFields: String, KeyEncodable {
        case address
        case name
        case identifier
    }
}

extension Wallet {
    @discardableResult
    /// Get a wallet from its address
    ///
    /// - Parameters:
    ///   - client: An API client.
    ///             This client need to be initialized with a AdminConfiguration struct before being used.
    ///   - params: The WalletGetParams object containing the address of the wallet to retrieve
    ///   - callback: The closure called when the request is completed
    /// - Returns: An optional cancellable request.
    public static func get(using client: HTTPAdminAPI,
                           params: WalletGetParams,
                           callback: @escaping Wallet.RetrieveRequestCallback) -> Wallet.RetrieveRequest? {
        return self.retrieve(using: client, endpoint: APIAdminEndpoint.getWallet(params: params), callback: callback)
    }
}

extension Wallet: PaginatedListable {
    @discardableResult
    /// Get all wallets for a user
    ///
    /// - Parameters:
    ///   - client: An API client.
    ///             This client need to be initialized with a AdminConfiguration struct before being used.
    ///   - callback: The closure called when the request is completed
    /// - Returns: An optional cancellable request.
    public static func getForUser(using client: HTTPAdminAPI,
                                  params: WalletListForUserParams,
                                  callback: @escaping Wallet.PaginatedListRequestCallback) -> Wallet.PaginatedListRequest? {
        return self.list(using: client, endpoint: APIAdminEndpoint.getWalletsForUser(params: params), callback: callback)
    }
}
