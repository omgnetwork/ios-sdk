//
//  TransactionExchange.swift
//  OmiseGO
//
//  Created by Mederic Petit on 27/2/18.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

/// Represents a transaction exchange
public struct TransactionExchange {
    /// The exchange rate used in the transaction. This can be nil if there was no exchange involved.
    public let rate: Double?
    /// The date when the exchange was processed
    public let calculatedAt: Date?
    /// The id of the exchange pair used
    public let exchangePairId: String?
    /// The exchange pair used in the exchange (if any)
    public let exchangePair: ExchangePair?
    /// The id of the account used for exchanging the funds
    public let exchangeAccountId: String?
    /// The account used for exchanging the funds
    public let exchangeAccount: Account?
    /// The address of the wallet used for exchanging the funds
    public let exchangeWalletAddress: String?
    /// The wallet used for exchanging the funds
    public let exchangeWallet: Wallet?
}

extension TransactionExchange: Decodable {
    private enum CodingKeys: String, CodingKey {
        case rate
        case calculatedAt = "calculated_at"
        case exchangePairId = "exchange_pair_id"
        case exchangePair = "exchange_pair"
        case exchangeAccountId = "exchange_account_id"
        case exchangeAccount = "exchange_account"
        case exchangeWalletAddress = "exchange_wallet_address"
        case exchangeWallet = "exchange_wallet"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        rate = try container.decodeIfPresent(Double.self, forKey: .rate)
        calculatedAt = try container.decodeIfPresent(Date.self, forKey: .calculatedAt)
        exchangePairId = try container.decodeIfPresent(String.self, forKey: .exchangePairId)
        exchangePair = try container.decodeIfPresent(ExchangePair.self, forKey: .exchangePair)
        exchangeAccountId = try container.decodeIfPresent(String.self, forKey: .exchangeAccountId)
        exchangeAccount = try container.decodeIfPresent(Account.self, forKey: .exchangeAccount)
        exchangeWalletAddress = try container.decodeIfPresent(String.self, forKey: .exchangeWalletAddress)
        exchangeWallet = try container.decodeIfPresent(Wallet.self, forKey: .exchangeWallet)
    }
}
