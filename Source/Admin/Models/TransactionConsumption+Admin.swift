//
//  TransactionConsumption+Admin.swift
//  OmiseGO
//
//  Created by Mederic Petit on 8/10/18.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

extension TransactionConsumption {
    @discardableResult
    /// Consume a transaction request from the given TransactionConsumptionParams object
    ///
    /// - Parameters:
    ///   - client: An API client.
    ///             This client need to be initialized with a AdminConfiguration struct before being used.
    ///   - params: The TransactionConsumptionParams object describing the transaction request to be consumed.
    ///   - callback: The closure called when the request is completed
    /// - Returns: An optional cancellable request.
    public static func consumeTransactionRequest(using client: HTTPAdminAPI,
                                                 params: TransactionConsumptionParams,
                                                 callback: @escaping TransactionConsumption.RetrieveRequestCallback)
        -> TransactionConsumption.RetrieveRequest? {
        return self.retrieve(using: client,
                             endpoint: APIAdminEndpoint.transactionRequestConsume(params: params),
                             callback: callback)
    }

    @discardableResult
    /// Approve the transaction consumption
    ///
    /// - Parameters:
    ///   - client: An API client.
    ///             This client need to be initialized with a AdminConfiguration struct before being used.
    ///   - callback: The closure called when the request is completed
    /// - Returns: An optional cancellable request.
    public func approve(using client: HTTPAdminAPI,
                        callback: @escaping TransactionConsumption.RetrieveRequestCallback)
        -> TransactionConsumption.RetrieveRequest? {
        let params = TransactionConsumptionConfirmationParams(id: id)
        return self.retrieve(using: client, endpoint: APIAdminEndpoint.transactionConsumptionApprove(params: params), callback: callback)
    }

    @discardableResult
    /// Reject the transaction consumption
    ///
    /// - Parameters:
    ///   - client: An API client.
    ///             This client need to be initialized with a AdminConfiguration struct before being used.
    ///   - callback: The closure called when the request is completed
    /// - Returns: An optional cancellable request.
    public func reject(using client: HTTPAdminAPI,
                       callback: @escaping TransactionConsumption.RetrieveRequestCallback)
        -> TransactionConsumption.RetrieveRequest? {
        let params = TransactionConsumptionConfirmationParams(id: id)
        return self.retrieve(using: client, endpoint: APIAdminEndpoint.transactionConsumptionReject(params: params), callback: callback)
    }
}
