//
//  TransactionRequestParams+Admin.swift
//  OmiseGO
//
//  Created by Mederic Petit on 8/10/18.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

import BigInt

extension TransactionRequestCreateParams {
    /// Initialize the params used to generate a transaction request.
    /// Returns nil if allowAmountOverride is false and amount is nil
    ///
    /// - Parameters:
    ///   - type: The type of transaction to be generated (send of receive)
    ///   - tokenId: The unique identifier of the token that will be used in the transaction
    ///   - amount: The amount of token to use for the transaction (down to subunit to unit)
    ///             This amount needs to be either specified by the requester or the consumer
    ///   - address: The address from which to send or receive the tokens
    ///              If not specified, will use the primary wallet address by default
    ///   - accountId: The account id creating the request
    ///   - userId: The user id of the user for whom the request is created
    ///   - providerUserId: The provider user id of the user for whom the request is created
    ///   - correlationId: An id that can uniquely identify a transaction. Typically an order id from a provider.
    ///   - requireConfirmation: A boolean indicating if the request needs a confirmation from the requester before being proceeded
    ///   - maxConsumptions: The maximum number of time that this request can be consumed
    ///   - consumptionLifetime: The amount of time in milisecond during which a consumption is valid
    ///   - expirationDate: The date when the request will expire and not be consumable anymore
    ///   - allowAmountOverride: Allow or not the consumer to override the amount specified in the request
    ///                          This needs to be true if the amount is not specified
    ///   - maxConsumptionsPerUser: The maximum number of consumptions allowed per unique user
    ///   - consumptionIntervalDuration: The duration (in milliseconds) during which the maxConsumptionsPerInterval and
    ///     maxConsumptionsPerIntervalPerUser attributes take effect.
    ///   - maxConsumptionsPerInterval: The total number of times the request can be consumed in the defined interval
    ///     (like 3 times every 24 hours)
    ///   - maxConsumptionsPerIntervalPerUser: The total number of times one unique user can consume the request
    ///     (like once every 24 hours)
    ///   - exchangeAccountId: The account to use for the token exchange (if any)
    ///   - exchangeWalletAddress: The wallet address to use for the token exchange (if any)
    ///   - metadata: Additional metadata embeded with the request
    ///   - encryptedMetadata: Additional encrypted metadata embedded with the request
    public init?(type: TransactionRequestType,
                 tokenId: String,
                 amount: BigInt?,
                 address: String? = nil,
                 accountId: String? = nil,
                 userId: String? = nil,
                 providerUserId: String? = nil,
                 correlationId: String? = nil,
                 requireConfirmation: Bool,
                 maxConsumptions: Int? = nil,
                 consumptionLifetime: Int? = nil,
                 expirationDate: Date? = nil,
                 allowAmountOverride: Bool,
                 maxConsumptionsPerUser: Int? = nil,
                 consumptionIntervalDuration: Int? = nil,
                 maxConsumptionsPerInterval: Int? = nil,
                 maxConsumptionsPerIntervalPerUser: Int? = nil,
                 exchangeAccountId: String? = nil,
                 exchangeWalletAddress: String? = nil,
                 metadata: [String: Any] = [:],
                 encryptedMetadata: [String: Any] = [:]) {
        guard allowAmountOverride || amount != nil else { return nil }
        self.type = type
        self.tokenId = tokenId
        self.amount = amount
        self.address = address
        self.accountId = accountId
        self.userId = userId
        self.providerUserId = providerUserId
        self.correlationId = correlationId
        self.requireConfirmation = requireConfirmation
        self.maxConsumptions = maxConsumptions
        self.consumptionLifetime = consumptionLifetime
        self.expirationDate = expirationDate
        self.allowAmountOverride = allowAmountOverride
        self.maxConsumptionsPerUser = maxConsumptionsPerUser
        self.consumptionIntervalDuration = consumptionIntervalDuration
        self.maxConsumptionsPerInterval = maxConsumptionsPerInterval
        self.maxConsumptionsPerIntervalPerUser = maxConsumptionsPerIntervalPerUser
        self.metadata = metadata
        self.encryptedMetadata = encryptedMetadata
        self.exchangeAccountId = exchangeAccountId
        self.exchangeWalletAddress = exchangeWalletAddress
    }
}
