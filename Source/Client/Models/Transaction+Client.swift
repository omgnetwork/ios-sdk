//
//  Transaction+Client.swift
//  OmiseGO
//
//  Created by Mederic Petit on 7/8/2018.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

extension Transaction: Retrievable {
    @discardableResult
    /// Create a new transaction
    ///
    /// - Parameters:
    ///   - client: An API client.
    ///             This client need to be initialized with a ClientConfiguration struct before being used.
    ///   - params: The TransactionSendParams object to customize the transaction
    ///   - callback: The closure called when the request is completed
    /// - Returns: An optional cancellable request.
    public static func create(using client: HTTPClient,
                              params: TransactionCreateParams,
                              callback: @escaping Transaction.RetrieveRequestCallback) -> Transaction.RetrieveRequest? {
        return self.retrieve(using: client, endpoint: APIClientEndpoint.createTransaction(params: params), callback: callback)
    }
}

extension Transaction: PaginatedListable {
    @discardableResult
    /// Get a paginated list of transaction for the current user
    ///
    /// - Parameters:
    ///   - client: An API client.
    ///             This client need to be initialized with a ClientConfiguration struct before being used.
    ///   - params: The TransactionListParams object to use to scope the results
    ///   - callback: The closure called when the request is completed
    /// - Returns: An optional cancellable request.
    public static func list(using client: HTTPClient,
                            params: TransactionListParams,
                            callback: @escaping Transaction.ListRequestCallback) -> Transaction.ListRequest? {
        return self.list(using: client, endpoint: APIClientEndpoint.getTransactions(params: params), callback: callback)
    }
}
