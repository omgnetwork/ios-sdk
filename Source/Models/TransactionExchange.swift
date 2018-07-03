//
//  TransactionExchange.swift
//  OmiseGO
//
//  Created by Mederic Petit on 27/2/18.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

/// Represents a transaction exchange
public struct TransactionExchange {

    /// The exchange rate used in the transaction
    public let rate: Double
    public let calculatedAt: Date?
    public let exchangePairId: String?
    public let exchangePair: ExchangePair?
    public let exchangeAccountId: String?
    public let exchangeAccount: Account?
    public let exchangeWalletAddress: String?
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
        rate = try container.decode(Double.self, forKey: .rate)
        calculatedAt = try container.decodeIfPresent(Date.self, forKey: .calculatedAt)
        exchangePairId = try container.decodeIfPresent(String.self, forKey: .exchangePairId)
        exchangePair = try container.decodeIfPresent(ExchangePair.self, forKey: .exchangePair)
        exchangeAccountId = try container.decodeIfPresent(String.self, forKey: .exchangeAccountId)
        exchangeAccount = try container.decodeIfPresent(Account.self, forKey: .exchangeAccount)
        exchangeWalletAddress = try container.decodeIfPresent(String.self, forKey: .exchangeWalletAddress)
        exchangeWallet = try container.decodeIfPresent(Wallet.self, forKey: .exchangeWallet)
    }

}
