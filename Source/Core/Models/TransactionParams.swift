//
//  TransactionParams.swift
//  OmiseGO
//
//  Created by Mederic Petit on 21/5/18.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

import BigInt

/// Represents a structure used to create a transaction
public struct TransactionCreateParams {
    /// The address from which to take the tokens (which must belong to the user).
    /// If not specified, the user's primary balance will be used.
    public let fromAddress: String?
    /// The address where to send the tokens
    public let toAddress: String?
    /// The provider user id where to send the token
    public let toProviderUserId: String?
    /// The account id where to send the tokens
    public let toAccountId: String?
    /// The amount of token to send (down to subunit to unit)
    public let amount: BigInt
    /// The id of the token that will be used to send the funds
    public let tokenId: String
    /// The idempotency token of the request
    public let idempotencyToken: String
    /// Additional metadata for the transaction
    public let metadata: [String: Any]
    /// Additional encrypted metadata for the transaction
    public let encryptedMetadata: [String: Any]

    private init(fromAddress: String?,
                 amount: BigInt,
                 tokenId: String,
                 toAddress: String?,
                 toAccountId: String?,
                 toProviderUserId: String?,
                 idempotencyToken: String,
                 metadata: [String: Any],
                 encryptedMetadata: [String: Any]) {
        self.fromAddress = fromAddress
        self.amount = amount
        self.tokenId = tokenId
        self.toAddress = toAddress
        self.toAccountId = toAccountId
        self.toProviderUserId = toProviderUserId
        self.idempotencyToken = idempotencyToken
        self.metadata = metadata
        self.encryptedMetadata = encryptedMetadata
    }

    public init(fromAddress: String? = nil,
                toAddress: String,
                amount: BigInt,
                tokenId: String,
                idempotencyToken: String,
                metadata: [String: Any] = [:],
                encryptedMetadata: [String: Any] = [:]) {
        self.init(fromAddress: fromAddress,
                  amount: amount,
                  tokenId: tokenId,
                  toAddress: toAddress,
                  toAccountId: nil,
                  toProviderUserId: nil,
                  idempotencyToken: idempotencyToken,
                  metadata: metadata,
                  encryptedMetadata: encryptedMetadata)
    }

    public init(fromAddress: String? = nil,
                toAccountId: String,
                toAddress: String? = nil,
                amount: BigInt,
                tokenId: String,
                idempotencyToken: String,
                metadata: [String: Any] = [:],
                encryptedMetadata: [String: Any] = [:]) {
        self.init(fromAddress: fromAddress,
                  amount: amount,
                  tokenId: tokenId,
                  toAddress: toAddress,
                  toAccountId: toAccountId,
                  toProviderUserId: nil,
                  idempotencyToken: idempotencyToken,
                  metadata: metadata,
                  encryptedMetadata: encryptedMetadata)
    }

    public init(fromAddress: String? = nil,
                toProviderUserId: String,
                toAddress: String? = nil,
                amount: BigInt,
                tokenId: String,
                idempotencyToken: String,
                metadata: [String: Any] = [:],
                encryptedMetadata: [String: Any] = [:]) {
        self.init(fromAddress: fromAddress,
                  amount: amount,
                  tokenId: tokenId,
                  toAddress: toAddress,
                  toAccountId: nil,
                  toProviderUserId: toProviderUserId,
                  idempotencyToken: idempotencyToken,
                  metadata: metadata,
                  encryptedMetadata: encryptedMetadata)
    }
}

extension TransactionCreateParams: APIParameters {
    private enum CodingKeys: String, CodingKey {
        case fromAddress = "from_address"
        case toAddress = "to_address"
        case toAccountId = "to_account_id"
        case toProviderUserId = "to_provider_user_id"
        case amount
        case tokenId = "token_id"
        case idempotencyToken = "idempotency_token"
        case metadata
        case encryptedMetadata = "encrypted_metadata"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(fromAddress, forKey: .fromAddress)
        try container.encodeIfPresent(toAddress, forKey: .toAddress)
        try container.encodeIfPresent(toAccountId, forKey: .toAccountId)
        try container.encodeIfPresent(toProviderUserId, forKey: .toProviderUserId)
        try container.encode(amount, forKey: .amount)
        try container.encode(tokenId, forKey: .tokenId)
        try container.encode(idempotencyToken, forKey: .idempotencyToken)
        try container.encode(metadata, forKey: .metadata)
        try container.encode(encryptedMetadata, forKey: .encryptedMetadata)
    }
}
