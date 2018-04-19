//
//  TransactionConsumptionParams.swift
//  OmiseGO
//
//  Created by Mederic Petit on 7/2/2018.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

/// Represents a structure used to consume a transaction request
public struct TransactionConsumptionParams {

    /// The id of the transaction request to be consumed
    public let transactionRequestId: String
    /// The amount of minted token to transfer (down to subunit to unit)
    public let amount: Double?
    /// The address to use for the consumption
    public let address: String?
    /// The id of the minted token to use for the request
    /// In the case of a type "send", this will be the token that the consumer will receive
    /// In the case of a type "receive" this will be the token that the consumer will send
    public let mintedTokenId: String?
    /// The idempotency token to use for the consumption
    public let idempotencyToken: String
    /// An id that can uniquely identify a transaction. Typically an order id from a provider.
    public let correlationId: String?
    /// Additional metadata for the consumption
    public let metadata: [String: Any]

    /// Initialize the params used to consume a transaction request
    /// Returns nil if the amount is nil and was not specified in the transaction request
    ///
    /// - Parameters:
    ///   - transactionRequest: The transaction request to consume
    ///   - address: The address to use for the consumption
    ///   - mintedTokenId: The id of the minted token to use for the request
    ///                    In the case of a type "send", this will be the token that the consumer will receive
    ///                    In the case of a type "receive" this will be the token that the consumer will send
    ///   - amount: The amount of minted token to transfer (down to subunit to unit)
    ///   - idempotencyToken: The idempotency token to use for the consumption
    ///   - correlationId: An id that can uniquely identify a transaction. Typically an order id from a provider.
    ///   - metadata: Additional metadata for the consumption
    public init?(transactionRequest: TransactionRequest,
                 address: String?,
                 mintedTokenId: String?,
                 amount: Double?,
                 idempotencyToken: String,
                 correlationId: String?,
                 metadata: [String: Any]) {
        guard transactionRequest.amount != nil || amount != nil else { return nil }
        self.transactionRequestId = transactionRequest.id
        self.amount = amount == transactionRequest.amount ? nil : amount
        self.address = address
        self.mintedTokenId = mintedTokenId
        self.idempotencyToken = idempotencyToken
        self.correlationId = correlationId
        self.metadata = metadata
    }

}

extension TransactionConsumptionParams: Parametrable {

    private enum CodingKeys: String, CodingKey {
        case transactionRequestId = "transaction_request_id"
        case amount
        case address
        case mintedTokenId = "token_id"
        case metadata
        case correlationId = "correlation_id"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(transactionRequestId, forKey: .transactionRequestId)
        try container.encode(amount, forKey: .amount)
        try container.encode(address, forKey: .address)
        try container.encode(mintedTokenId, forKey: .mintedTokenId)
        try container.encode(metadata, forKey: .metadata)
        try container.encode(correlationId, forKey: .correlationId)
    }

}

/// Represents a structure used to confirm a transaction consumption from its id
struct TransactionConsumptionConfirmationParams: Parametrable {

    let id: String

}
