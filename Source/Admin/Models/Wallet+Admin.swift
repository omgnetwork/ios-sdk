//
//  Wallet+Admin.swift
//  OmiseGO
//
//  Created by Mederic Petit on 17/9/18.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

extension Wallet: Filterable {
    public enum FilterableFields: String, RawEnumerable {
        case address
        case name
        case identifier
        case enabled
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

extension Wallet: Sortable {
    public enum SortableFields: String, RawEnumerable {
        case address
        case name
        case identifier
        case createdAt = "created_at"
        case updatedAt = "updated_at"
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
    /// Get a paginated list of wallets for a user
    ///
    /// - Parameters:
    ///   - client: An API client.
    ///             This client need to be initialized with a AdminConfiguration struct before being used.
    ///   - params: The WalletListForUserParams object containing the user id and the pagination informations
    ///   - callback: The closure called when the request is completed
    /// - Returns: An optional cancellable request.
    public static func listForUser(using client: HTTPAdminAPI,
                                   params: WalletListForUserParams,
                                   callback: @escaping Wallet.PaginatedListRequestCallback) -> Wallet.PaginatedListRequest? {
        return self.list(using: client, endpoint: APIAdminEndpoint.getWalletsForUser(params: params), callback: callback)
    }

    @discardableResult
    /// Get a paginated list of wallets for an account
    ///
    /// - Parameters:
    ///   - client: An API client.
    ///             This client need to be initialized with a AdminConfiguration struct before being used.
    ///   - params: The WalletListForAccountParams object containing the account id and the pagination informations
    ///   - callback: The closure called when the request is completed
    /// - Returns: An optional cancellable request.
    public static func listForAccount(using client: HTTPAdminAPI,
                                      params: WalletListForAccountParams,
                                      callback: @escaping Wallet.PaginatedListRequestCallback) -> Wallet.PaginatedListRequest? {
        return self.list(using: client, endpoint: APIAdminEndpoint.getWalletsForAccount(params: params), callback: callback)
    }
}
