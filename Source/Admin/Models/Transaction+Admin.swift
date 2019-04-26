//
//  Transaction+Admin.swift
//  OmiseGO
//
//  Created by Mederic Petit on 19/9/18.
//  Copyright © 2017-2019 Omise Go Pte. Ltd. All rights reserved.
//

extension Transaction {
    @discardableResult
    /// Create a new transaction
    ///
    /// - Parameters:
    ///   - client: An API client.
    ///             This client need to be initialized with a ClientConfiguration struct before being used.
    ///   - params: The TransactionSendParams object to customize the transaction
    ///   - callback: The closure called when the request is completed
    /// - Returns: An optional cancellable request.
    public static func create(using client: HTTPAdminAPI,
                              params: TransactionCreateParams,
                              callback: @escaping Transaction.RetrieveRequestCallback) -> Transaction.RetrieveRequest? {
        return self.retrieve(using: client, endpoint: APIAdminEndpoint.createTransaction(params: params), callback: callback)
    }

    @discardableResult
    /// Get a paginated list of transactions
    ///
    /// - Parameters:
    ///   - client: An API client.
    ///             This client need to be initialized with a ClientConfiguration struct before being used.
    ///   - params: The PaginatedListParams<Transaction> object to use to scope the results
    ///   - callback: The closure called when the request is completed
    /// - Returns: An optional cancellable request.
    public static func list(using client: HTTPAdminAPI,
                            params: PaginatedListParams<Transaction>,
                            callback: @escaping Transaction.PaginatedListRequestCallback) -> Transaction.PaginatedListRequest? {
        return self.list(using: client, endpoint: APIAdminEndpoint.getTransactions(params: params), callback: callback)
    }
}
