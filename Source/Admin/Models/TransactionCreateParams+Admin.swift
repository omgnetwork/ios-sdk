//
//  TransactionCreateParams+Admin.swift
//  OmiseGO
//
//  Created by Mederic Petit on 19/9/18.
//  Copyright © 2017-2019 Omise Go Pte. Ltd. All rights reserved.
//

import BigInt

extension TransactionCreateParams {
    public init(fromAddress: String?,
                toAddress: String?,
                amount: BigInt?,
                fromAmount: BigInt?,
                toAmount: BigInt?,
                fromTokenId: String?,
                toTokenId: String?,
                tokenId: String?,
                fromAccountId: String?,
                toAccountId: String?,
                fromProviderUserId: String?,
                toProviderUserId: String?,
                fromUserId: String?,
                toUserId: String?,
                idempotencyToken: String,
                exchangeAccountId: String?,
                exchangeAddress: String?,
                metadata: [String: Any],
                encryptedMetadata: [String: Any]) {
        self.fromAddress = fromAddress
        self.toAddress = toAddress
        self.amount = amount
        self.fromAmount = fromAmount
        self.toAmount = toAmount
        self.fromTokenId = fromTokenId
        self.toTokenId = toTokenId
        self.tokenId = tokenId
        self.fromAccountId = fromAccountId
        self.toAccountId = toAccountId
        self.fromProviderUserId = fromProviderUserId
        self.toProviderUserId = toProviderUserId
        self.fromUserId = fromUserId
        self.toUserId = toUserId
        self.idempotencyToken = idempotencyToken
        self.metadata = metadata
        self.encryptedMetadata = encryptedMetadata
        self.exchangeAddress = exchangeAddress
        self.exchangeAccountId = exchangeAccountId
    }
}
