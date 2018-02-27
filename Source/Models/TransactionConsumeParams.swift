//
//  TransactionConsumeParams.swift
//  OmiseGO
//
//  Created by Mederic Petit on 7/2/2018 BE.
//  Copyright © 2018 OmiseGO. All rights reserved.
//

/// Represents a structure used to consume a transaction request
public struct TransactionConsumeParams {

    public let transactionRequestId: String
    public let amount: Double
    public let address: String?
    public let mintedTokenId: String?
    public let idempotencyToken: String
    public let correlationId: String?
    public let metadata: [String: Any]

    public init?(transactionRequest: TransactionRequest,
                 address: String?,
                 mintedTokenId: String?,
                 amount: Double? = nil,
                 idempotencyToken: String,
                 correlationId: String?,
                 metadata: [String: Any]) {
        guard let amount = (amount != nil ? amount : transactionRequest.amount) else { return nil }
        self.transactionRequestId = transactionRequest.id
        self.amount = amount
        self.address = address
        self.mintedTokenId = mintedTokenId
        self.idempotencyToken = idempotencyToken
        self.correlationId = correlationId
        self.metadata = metadata
    }

}

extension TransactionConsumeParams: Parametrable {

    private enum CodingKeys: String, CodingKey {
        case transactionRequestId = "transaction_request_id"
        case amount
        case address
        case mintedTokenId = "token_id"
        case metadata
        case correlationId = "correlation_id"
    }

    func encodedPayload() -> Data? {
        return try? JSONEncoder().encode(self)
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
