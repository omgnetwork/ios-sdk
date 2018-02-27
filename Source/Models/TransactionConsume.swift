//
//  TransactionConsume.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 13/2/2018 BE.
//  Copyright © 2018 OmiseGO. All rights reserved.
//
// swiftlint:disable identifier_name

/// The status of a transaction consumption
///
/// - pending: The transaction consumption is pending validation
/// - confirmed: The transaction was consumed
/// - failed: The transaction failed to be consumed
public enum TransactionConsumeStatus: String, Decodable {
    case pending
    case confirmed
    case failed
}

/// Represents a transaction consumption
public struct TransactionConsume: Decodable {

    public let id: String
    public let status: TransactionConsumeStatus
    public let amount: Double
    public let mintedToken: MintedToken
    public let correlationId: String?
    public let idempotencyToken: String
    public let transactionId: String
    public let userId: String
    public let transactionRequestId: String
    public let address: String

    private enum CodingKeys: String, CodingKey {
        case id
        case status
        case amount
        case mintedToken = "minted_token"
        case correlationId = "correlation_id"
        case idempotencyToken = "idempotency_token"
        case transactionId = "transaction_id"
        case userId = "user_id"
        case transactionRequestId = "transaction_request_id"
        case address
    }

}

extension TransactionConsume: Retrievable {

    @discardableResult
    /// Consume a transaction request from the given TransactionConsumeParams object
    ///
    /// - Parameters:
    ///   - client: An API client.
    ///             This client need to be initialized with a OMGConfiguration struct before being used.
    ///   - params: The TransactionConsumeParams object describing the transaction request to be consumed.
    ///   - callback: The closure called when the request is completed
    /// - Returns: An optional cancellable request.
    public static func consumeTransactionRequest(using client: OMGClient,
                                                 params: TransactionConsumeParams,
                                                 callback: @escaping TransactionConsume.RetrieveRequestCallback)
        -> TransactionConsume.RetrieveRequest? {
            return self.retrieve(using: client,
                                 endpoint: .transactionRequestConsume(params: params),
                                 callback: callback)
    }

}

extension TransactionConsume: Hashable {

    public var hashValue: Int {
        return self.id.hashValue
    }

}

// MARK: Equatable

public func == (lhs: TransactionConsume, rhs: TransactionConsume) -> Bool {
    return lhs.id == rhs.id
}
