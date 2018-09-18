//
//  WalletGetForUserParams.swift
//  OmiseGO
//
//  Created by Mederic Petit on 17/9/18.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

/// Represents a structure used to retrieve wallets for a specific user
public struct WalletListForUserParams {
    public let paginatedListParams: PaginatedListParams<Wallet>
    public let userId: String?
    public let providerUserId: String?

    /// Initialize the params used to query a paginated list of wallets belonging to a user from its userId
    ///
    /// - Parameters:
    ///   - paginatedListParams: The params to use for the pagination
    ///   - userId: The id of the user
    public init(paginatedListParams: PaginatedListParams<Wallet>,
                userId: String) {
        self.paginatedListParams = paginatedListParams
        self.userId = userId
        self.providerUserId = nil
    }

    /// Initialize the params used to query a paginated list of wallets belonging to a user from its providerUserId
    ///
    /// - Parameters:
    ///   - paginatedListParams: The params to use for the pagination
    ///   - providerUserId: The id of the user
    public init(paginatedListParams: PaginatedListParams<Wallet>,
                providerUserId: String) {
        self.paginatedListParams = paginatedListParams
        self.providerUserId = providerUserId
        self.userId = nil
    }
}

extension WalletListForUserParams: APIParameters {
    private enum CodingKeys: String, CodingKey {
        case paginatedListParams
        case userId = "id"
        case providerUserId = "provider_user_id"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try paginatedListParams.encode(to: encoder)
        try container.encodeIfPresent(userId, forKey: .userId)
        try container.encodeIfPresent(providerUserId, forKey: .providerUserId)
    }
}
