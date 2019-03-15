//
//  TransactionConsumption+Client.swift
//  Tests
//
//  Created by Mederic Petit on 7/8/2018.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

extension TransactionConsumption {
    @discardableResult
    /// Consume a transaction request from the given TransactionConsumptionParams object
    ///
    /// - Parameters:
    ///   - client: An API client.
    ///             This client need to be initialized with a ClientConfiguration struct before being used.
    ///   - params: The TransactionConsumptionParams object describing the transaction request to be consumed.
    ///   - callback: The closure called when the request is completed
    /// - Returns: An optional cancellable request.
    public static func consumeTransactionRequest(using client: HTTPClientAPI,
                                                 params: TransactionConsumptionParams,
                                                 callback: @escaping TransactionConsumption.RetrieveRequestCallback)
        -> TransactionConsumption.RetrieveRequest? {
        return self.retrieve(using: client,
                             endpoint: APIClientEndpoint.transactionRequestConsume(params: params),
                             callback: callback)
    }

    @discardableResult
    /// Cancel the transaction consumption
    ///
    /// - Parameters:
    ///   - client: An API client.
    ///             This client need to be initialized with a ClientConfiguration struct before being used.
    ///   - callback: The closure called when the request is completed
    /// - Returns: An optional cancellable request.
    public func cancel(using client: HTTPClientAPI,
                       callback: @escaping TransactionConsumption.RetrieveRequestCallback)
        -> TransactionConsumption.RetrieveRequest? {
        let params = TransactionConsumptionCancellationParams(id: id)
        return self.retrieve(using: client, endpoint: APIClientEndpoint.transactionConsumptionCancel(params: params), callback: callback)
    }

    @discardableResult
    /// Approve the transaction consumption
    ///
    /// - Parameters:
    ///   - client: An API client.
    ///             This client need to be initialized with a ClientConfiguration struct before being used.
    ///   - callback: The closure called when the request is completed
    /// - Returns: An optional cancellable request.
    public func approve(using client: HTTPClientAPI,
                        callback: @escaping TransactionConsumption.RetrieveRequestCallback)
        -> TransactionConsumption.RetrieveRequest? {
        let params = TransactionConsumptionConfirmationParams(id: id)
        return self.retrieve(using: client, endpoint: APIClientEndpoint.transactionConsumptionApprove(params: params), callback: callback)
    }

    @discardableResult
    /// Reject the transaction consumption
    ///
    /// - Parameters:
    ///   - client: An API client.
    ///             This client need to be initialized with a ClientConfiguration struct before being used.
    ///   - callback: The closure called when the request is completed
    /// - Returns: An optional cancellable request.
    public func reject(using client: HTTPClientAPI,
                       callback: @escaping TransactionConsumption.RetrieveRequestCallback)
        -> TransactionConsumption.RetrieveRequest? {
        let params = TransactionConsumptionConfirmationParams(id: id)
        return self.retrieve(using: client, endpoint: APIClientEndpoint.transactionConsumptionReject(params: params), callback: callback)
    }
}
