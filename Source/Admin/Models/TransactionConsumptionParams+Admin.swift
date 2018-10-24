//
//  TransactionConsumptionParams+Admin.swift
//  OmiseGO
//
//  Created by Mederic Petit on 8/10/18.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

import BigInt

extension TransactionConsumptionParams {
    /// Initialize the params used to consume a transaction request
    /// Returns nil if the amount is nil and was not specified in the transaction request
    ///
    /// - Parameters:
    ///   - formattedTransactionRequestId: The formatted id of the transaction request to consume
    ///   - address: The address to use for the consumption
    ///   - accountId: The account id consuming the request
    ///   - userId: The user id of the user for whom the request is consumed
    ///   - providerUserId: The provider user id of the user for whom the request is consumed
    ///   - amount: The amount of token to transfer (down to subunit to unit)
    ///   - idempotencyToken: The idempotency token to use for the consumption
    ///   - correlationId: An id that can uniquely identify a transaction. Typically an order id from a provider.
    ///   - tokenId: The id of the token to use for the consumption.
    ///              If different from the request, the exchange account or wallet address must be specified
    ///   - exchangeAccountId: The account to use for the token exchange (if any)
    ///   - exchangeWalletAddress: The wallet address to use for the token exchange (if any)
    ///   - metadata: Additional metadata for the consumption
    ///   - encryptedMetadata: Additional encrypted metadata embedded with the request
    public init(formattedTransactionRequestId: String,
                address: String? = nil,
                accountId: String? = nil,
                userId: String? = nil,
                providerUserId: String? = nil,
                amount: BigInt?,
                idempotencyToken: String,
                correlationId: String? = nil,
                tokenId: String? = nil,
                exchangeAccountId: String? = nil,
                exchangeWalletAddress: String? = nil,
                metadata: [String: Any] = [:],
                encryptedMetadata: [String: Any] = [:]) {
        self.formattedTransactionRequestId = formattedTransactionRequestId
        self.amount = amount
        self.address = address
        self.accountId = accountId
        self.userId = userId
        self.providerUserId = providerUserId
        self.idempotencyToken = idempotencyToken
        self.correlationId = correlationId
        self.metadata = metadata
        self.encryptedMetadata = encryptedMetadata
        self.tokenId = tokenId
        self.exchangeAccountId = exchangeAccountId
        self.exchangeWalletAddress = exchangeWalletAddress
    }

    /// Initialize the params used to consume a transaction request
    /// Returns nil if the amount is nil and was not specified in the transaction request
    ///
    /// - Parameters:
    ///   - transactionRequest: The transaction request to consume
    ///   - address: The address to use for the consumption
    ///   - accountId: The account id consuming the request
    ///   - userId: The user id of the user for whom the request is consumed
    ///   - providerUserId: The provider user id of the user for whom the request is consumed
    ///   - amount: The amount of token to transfer (down to subunit to unit)
    ///   - idempotencyToken: The idempotency token to use for the consumption
    ///   - correlationId: An id that can uniquely identify a transaction. Typically an order id from a provider.
    ///   - tokenId: The id of the token to use for the consumption.
    ///              If different from the request, the exchange account or wallet address must be specified
    ///   - exchangeAccountId: The account to use for the token exchange (if any)
    ///   - exchangeWalletAddress: The wallet address to use for the token exchange (if any)
    ///   - metadata: Additional metadata for the consumption
    ///   - encryptedMetadata: Additional encrypted metadata embedded with the request
    public init?(transactionRequest: TransactionRequest,
                 address: String? = nil,
                 accountId: String? = nil,
                 userId: String? = nil,
                 providerUserId: String? = nil,
                 amount: BigInt?,
                 idempotencyToken: String,
                 correlationId: String? = nil,
                 tokenId: String? = nil,
                 exchangeAccountId: String? = nil,
                 exchangeWalletAddress: String? = nil,
                 metadata: [String: Any] = [:],
                 encryptedMetadata: [String: Any] = [:]) {
        guard transactionRequest.amount != nil || amount != nil else { return nil }
        self.formattedTransactionRequestId = transactionRequest.formattedId
        self.amount = amount == transactionRequest.amount ? nil : amount
        self.address = address
        self.accountId = accountId
        self.userId = userId
        self.providerUserId = providerUserId
        self.idempotencyToken = idempotencyToken
        self.correlationId = correlationId
        self.metadata = metadata
        self.encryptedMetadata = encryptedMetadata
        self.tokenId = tokenId
        self.exchangeAccountId = exchangeAccountId
        self.exchangeWalletAddress = exchangeWalletAddress
    }
}
