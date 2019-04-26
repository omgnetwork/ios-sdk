//
//  Wallet.swift
//  OmiseGO
//
//  Created by Thibault Denizet on 12/10/2017.
//  Copyright © 2017-2019 Omise Go Pte. Ltd. All rights reserved.
//

/// Represents a wallet containing a list of balances
public struct Wallet: Retrievable, Listable {
    /// The address of the wallet
    public let address: String
    /// The list of balances associated with that address
    public let balances: [Balance]
    /// The name of the wallet
    public let name: String
    /// The identifier of the wallet
    public let identifier: String
    /// The id of the user associated to this wallet if it's a user wallet. Nil if it's an account wallet.
    public let userId: String?
    /// The user associated to this wallet if it's a user wallet. Nil if it's an account wallet.
    public let user: User?
    /// The id of the account associated to this wallet if it's an account wallet. Nil if it's a user wallet.
    public let accountId: String?
    /// The account associated to this wallet if it's an account wallet. Nil if it's a user wallet.
    public let account: Account?
    /// Any additional metadata that need to be stored as a dictionary
    public let metadata: [String: Any]
    /// Any additional encrypted metadata that need to be stored as a dictionary
    public let encryptedMetadata: [String: Any]
}

extension Wallet: Decodable {
    private enum CodingKeys: String, CodingKey {
        case id
        case address
        case balances
        case name
        case identifier
        case userId = "user_id"
        case user
        case accountId = "account_id"
        case account
        case metadata
        case encryptedMetadata = "encrypted_metadata"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        address = try container.decode(String.self, forKey: .address)
        let decodedBalances = try container.decodeIfPresent([Balance].self, forKey: .balances)
        if let balances = decodedBalances {
            self.balances = balances
        } else {
            self.balances = []
        }
        self.name = try container.decode(String.self, forKey: .name)
        self.identifier = try container.decode(String.self, forKey: .identifier)
        self.userId = try container.decodeIfPresent(String.self, forKey: .userId)
        self.user = try container.decodeIfPresent(User.self, forKey: .user)
        self.accountId = try container.decodeIfPresent(String.self, forKey: .accountId)
        self.account = try container.decodeIfPresent(Account.self, forKey: .account)
        self.metadata = try container.decode([String: Any].self, forKey: .metadata)
        self.encryptedMetadata = try container.decode([String: Any].self, forKey: .encryptedMetadata)
    }
}

extension Wallet: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(self.address)
    }

    public static func == (lhs: Wallet, rhs: Wallet) -> Bool {
        return lhs.address == rhs.address
    }
}
