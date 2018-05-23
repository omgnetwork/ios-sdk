//
//  TransactionParams.swift
//  OmiseGO
//
//  Created by Mederic Petit on 21/5/18.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

/// Represents a structure used to create a transaction
public struct TransactionSendParams {

    /// The address from which to take the tokens (which must belong to the user).
    /// If not specified, the user's primary balance will be used.
    public let from: String?
    /// The address where to send the tokens
    public let to: String
    /// The amount of minted token to transfer (down to subunit to unit)
    public let amount: Double
    /// The id of the minted token to send
    public let mintedTokenId: String
    /// Additional metadata for the transaction
    public let metadata: [String: Any]
    /// Additional encrypted metadata for the transaction
    public let encryptedMetadata: [String: Any]

    public init(from: String? = nil,
                to: String,
                amount: Double,
                mintedTokenId: String,
                metadata: [String: Any] = [:],
                encryptedMetadata: [String: Any] = [:]) {
        self.from = from
        self.to = to
        self.amount = amount
        self.mintedTokenId = mintedTokenId
        self.metadata = metadata
        self.encryptedMetadata = encryptedMetadata
    }

}

extension TransactionSendParams: APIParameters {

    private enum CodingKeys: String, CodingKey {
        case from = "from_address"
        case to = "to_address"
        case amount
        case mintedTokenId = "token_id"
        case metadata
        case encryptedMetadata = "encrypted_metadata"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(from, forKey: .from)
        try container.encode(to, forKey: .to)
        try container.encode(amount, forKey: .amount)
        try container.encode(mintedTokenId, forKey: .mintedTokenId)
        try container.encode(metadata, forKey: .metadata)
        try container.encode(encryptedMetadata, forKey: .encryptedMetadata)
    }

}
