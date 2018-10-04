//
//  WalletListForAccountParams.swift
//  OmiseGO
//
//  Created by Mederic Petit on 18/9/18.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

import UIKit

/// Represents a structure used to retrieve wallets for a specific user
public struct WalletListForAccountParams {
    /// The pagination params
    public let paginatedListParams: PaginatedListParams<Wallet>
    /// The account id
    public let accountId: String
    /// Query only wallets belonging to the specified account OR also its children
    public let owned: Bool

    /// Initialize the params used to query a paginated list of wallets belonging to an account from its id
    ///
    /// - Parameters:
    ///   - paginatedListParams: The params to use for the pagination
    ///   - accountId: The id of the account
    public init(paginatedListParams: PaginatedListParams<Wallet>,
                accountId: String,
                owned: Bool) {
        self.paginatedListParams = paginatedListParams
        self.accountId = accountId
        self.owned = owned
    }
}

extension WalletListForAccountParams: APIParameters {
    private enum CodingKeys: String, CodingKey {
        case paginatedListParams
        case accountId = "id"
        case owned
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try paginatedListParams.encode(to: encoder)
        try container.encode(accountId, forKey: .accountId)
        try container.encode(owned, forKey: .owned)
    }
}
