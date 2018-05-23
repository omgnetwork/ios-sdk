//
//  Wallet.swift
//  OmiseGO
//
//  Created by Thibault Denizet on 12/10/2017.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

/// Represents a wallet containing a list of balances
public struct Wallet: Retrievable {

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
        balances = try container.decode([Balance].self, forKey: .balances)
        name = try container.decode(String.self, forKey: .name)
        identifier = try container.decode(String.self, forKey: .identifier)
        userId = try container.decodeIfPresent(String.self, forKey: .userId)
        user = try container.decodeIfPresent(User.self, forKey: .user)
        accountId = try container.decodeIfPresent(String.self, forKey: .accountId)
        account = try container.decodeIfPresent(Account.self, forKey: .account)
        metadata = try container.decode([String: Any].self, forKey: .metadata)
        encryptedMetadata = try container.decode([String: Any].self, forKey: .encryptedMetadata)
    }

}

extension Wallet: Listable {

    @discardableResult
    /// Get all wallets of the current user
    ///
    /// - Parameters:
    ///   - client: An API client.
    ///             This client need to be initialized with a ClientConfiguration struct before being used.
    ///   - callback: The closure called when the request is completed
    /// - Returns: An optional cancellable request.
    public static func getAll(using client: HTTPClient,
                              callback: @escaping Wallet.ListRequestCallback) -> Wallet.ListRequest? {
        return self.list(using: client, endpoint: .getWallets, callback: callback)
    }

    @discardableResult
    /// Get the main wallet for the current user
    ///
    /// - Parameters:
    ///   - client: An API client.
    ///             This client need to be initialized with a ClientConfiguration struct before being used.
    ///   - callback: The closure called when the request is completed
    /// - Returns: An optional cancellable request.
    public static func getMain(using client: HTTPClient,
                               callback: @escaping Wallet.RetrieveRequestCallback) -> Wallet.ListRequest? {
        return self.list(using: client, endpoint: .getWallets, callback: { (response) in
            switch response {
            case .success(data: let wallets):
                if wallets.isEmpty {
                    callback(Response.fail(error: OMGError.unexpected(message: "No wallet received.")))
                } else {
                    callback(.success(data: wallets.first!))
                }
            case .fail(error: let error):
                callback(.fail(error: error))
            }

        })
    }

}

extension Wallet: Hashable {

    public var hashValue: Int {
        return self.address.hashValue
    }

    public static func == (lhs: Wallet, rhs: Wallet) -> Bool {
        return lhs.address == rhs.address
    }

}
