//
//  TransactionParams.swift
//  OmiseGO
//
//  Created by Mederic Petit on 21/5/18.
//  Copyright © 2017-2019 Omise Go Pte. Ltd. All rights reserved.
//

import BigInt

/// Represents a structure used to create a transaction
public struct TransactionCreateParams {
    /// The address from which to take the tokens (which must belong to the user).
    public let fromAddress: String?
    /// The address where to send the tokens
    public let toAddress: String?
    /// The provider user id where to take the token from
    public let fromProviderUserId: String?
    /// The provider user id where to send the token
    public let toProviderUserId: String?
    /// The user id where to take the token from
    public let fromUserId: String?
    /// The user id where to send the token
    public let toUserId: String?
    /// The account id where to take the token from
    public let fromAccountId: String?
    /// The account id where to send the tokens
    public let toAccountId: String?
    /// The amount of token to send (down to subunit to unit)
    public let amount: BigInt?
    /// The amount of token to send (down to subunit to unit)
    public let fromAmount: BigInt?
    /// The amount of token expected to be received (down to subunit to unit)
    public let toAmount: BigInt?
    /// The id of the token that will be used to send or receive the funds
    public let tokenId: String?
    /// The id of the token that will be used to send the funds
    public let fromTokenId: String?
    /// The id of the token that will be used to receive the funds
    public let toTokenId: String?
    /// The idempotency token of the request
    public let idempotencyToken: String
    /// The account id to use for exchanging the tokens
    public let exchangeAccountId: String?
    /// The address to use for exchanging the tokens
    public let exchangeAddress: String?
    /// Additional metadata for the transaction
    public let metadata: [String: Any]
    /// Additional encrypted metadata for the transaction
    public let encryptedMetadata: [String: Any]

    public init(fromAddress: String? = nil,
                toAddress: String,
                amount: BigInt,
                tokenId: String,
                idempotencyToken: String,
                metadata: [String: Any] = [:],
                encryptedMetadata: [String: Any] = [:]) {
        self.fromAddress = fromAddress
        self.toAddress = toAddress
        self.amount = amount
        self.fromAmount = nil
        self.toAmount = nil
        self.fromTokenId = nil
        self.toTokenId = nil
        self.tokenId = tokenId
        self.fromAccountId = nil
        self.toAccountId = nil
        self.fromProviderUserId = nil
        self.toProviderUserId = nil
        self.fromUserId = nil
        self.toUserId = nil
        self.idempotencyToken = idempotencyToken
        self.metadata = metadata
        self.encryptedMetadata = encryptedMetadata
        self.exchangeAddress = nil
        self.exchangeAccountId = nil
    }

    public init(fromAddress: String? = nil,
                toAccountId: String,
                toAddress: String? = nil,
                amount: BigInt,
                tokenId: String,
                idempotencyToken: String,
                metadata: [String: Any] = [:],
                encryptedMetadata: [String: Any] = [:]) {
        self.fromAddress = fromAddress
        self.toAddress = toAddress
        self.amount = amount
        self.fromAmount = nil
        self.toAmount = nil
        self.fromTokenId = nil
        self.toTokenId = nil
        self.tokenId = tokenId
        self.fromAccountId = nil
        self.toAccountId = toAccountId
        self.fromProviderUserId = nil
        self.toProviderUserId = nil
        self.fromUserId = nil
        self.toUserId = nil
        self.idempotencyToken = idempotencyToken
        self.metadata = metadata
        self.encryptedMetadata = encryptedMetadata
        self.exchangeAddress = nil
        self.exchangeAccountId = nil
    }

    public init(fromAddress: String? = nil,
                toProviderUserId: String,
                toAddress: String? = nil,
                amount: BigInt,
                tokenId: String,
                idempotencyToken: String,
                metadata: [String: Any] = [:],
                encryptedMetadata: [String: Any] = [:]) {
        self.fromAddress = fromAddress
        self.toAddress = toAddress
        self.amount = amount
        self.fromAmount = nil
        self.toAmount = nil
        self.fromTokenId = nil
        self.toTokenId = nil
        self.tokenId = tokenId
        self.fromAccountId = nil
        self.toAccountId = nil
        self.fromProviderUserId = nil
        self.toProviderUserId = toProviderUserId
        self.fromUserId = nil
        self.toUserId = nil
        self.idempotencyToken = idempotencyToken
        self.metadata = metadata
        self.encryptedMetadata = encryptedMetadata
        self.exchangeAddress = nil
        self.exchangeAccountId = nil
    }
}

extension TransactionCreateParams: APIParameters {
    private enum CodingKeys: String, CodingKey {
        case fromAddress = "from_address"
        case toAddress = "to_address"
        case fromProviderUserId = "from_provider_user_id"
        case toProviderUserId = "to_provider_user_id"
        case fromUserId = "from_user_id"
        case toUserId = "to_user_id"
        case fromAccountId = "from_account_id"
        case toAccountId = "to_account_id"
        case amount
        case fromAmount = "from_amount"
        case toAmount = "to_amount"
        case tokenId = "token_id"
        case fromTokenId = "from_token_id"
        case toTokenId = "to_token_id"
        case idempotencyToken = "idempotency_token"
        case exchangeAccountId = "exchange_account_id"
        case exchangeAddress = "exchange_address"
        case metadata
        case encryptedMetadata = "encrypted_metadata"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(fromAddress, forKey: .fromAddress)
        try container.encodeIfPresent(toAddress, forKey: .toAddress)
        try container.encodeIfPresent(fromProviderUserId, forKey: .fromProviderUserId)
        try container.encodeIfPresent(toProviderUserId, forKey: .toProviderUserId)
        try container.encodeIfPresent(fromUserId, forKey: .fromUserId)
        try container.encodeIfPresent(toUserId, forKey: .toUserId)
        try container.encodeIfPresent(fromAccountId, forKey: .fromAccountId)
        try container.encodeIfPresent(toAccountId, forKey: .toAccountId)
        try container.encodeIfPresent(amount, forKey: .amount)
        try container.encodeIfPresent(fromAmount, forKey: .fromAmount)
        try container.encodeIfPresent(toAmount, forKey: .toAmount)
        try container.encodeIfPresent(tokenId, forKey: .tokenId)
        try container.encodeIfPresent(fromTokenId, forKey: .fromTokenId)
        try container.encodeIfPresent(toTokenId, forKey: .toTokenId)
        try container.encode(idempotencyToken, forKey: .idempotencyToken)
        try container.encodeIfPresent(exchangeAccountId, forKey: .exchangeAccountId)
        try container.encodeIfPresent(exchangeAddress, forKey: .exchangeAddress)
        try container.encode(metadata, forKey: .metadata)
        try container.encode(encryptedMetadata, forKey: .encryptedMetadata)
    }
}
