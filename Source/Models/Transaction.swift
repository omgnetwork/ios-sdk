//
//  Transaction.swift
//  OmiseGO
//
//  Created by Mederic Petit on 23/2/18.
//  Copyright © 2018 OmiseGO. All rights reserved.
//
// swiftlint:disable identifier_name

/// The status of a transaction
///
/// - pending: The transaction is pending
/// - confirmed: The transaction is confirmed
/// - failed: The transaction failed
public enum TransactionStatus: String, Decodable {
    case pending
    case confirmed
    case failed
}

/// Represents a transaction
public struct Transaction: Decodable {

    public let id: String
    public let status: TransactionConsumeStatus
    public let amount: Double
    public let mintedToken: MintedToken
    public let from: String
    public let to: String
    public let createdAt: Date
    public let updatedAt: Date

    private enum CodingKeys: String, CodingKey {
        case id
        case status
        case amount
        case from
        case to
        case mintedToken = "minted_token"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }

}

extension Transaction: PaginatedListable {

    @discardableResult
    /// Get a paginated list of transaction for the current user
    ///
    /// - Parameters:
    ///   - client: An API client.
    ///             This client need to be initialized with a OMGConfiguration struct before being used.
    ///   - params: The TransactionListParams object to use to scope the results
    ///   - callback: The closure called when the request is completed
    /// - Returns: An optional cancellable request.
    public static func list(using client: OMGClient,
                            params: TransactionListParams,
                            callback: @escaping Transaction.ListRequestCallback) -> Transaction.ListRequest? {
        return self.list(using: client, endpoint: .getTransactions(params: params), callback: callback)
    }

}

extension Transaction: Paginable {

    public enum SearchableFields: String, KeyEncodable {
        case id
        case status
        case from
        case to
    }

    public enum SortableFields: String, KeyEncodable {
        case id
        case status
        case from
        case to
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }

}

extension Transaction: Hashable {

    public var hashValue: Int {
        return self.id.hashValue
    }

}

// MARK: Equatable

public func == (lhs: Transaction, rhs: Transaction) -> Bool {
    return lhs.id == rhs.id
}
