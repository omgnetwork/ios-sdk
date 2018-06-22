//
//  TransactionRequest.swift
//  OmiseGO
//
//  Created by Mederic Petit on 5/2/2018.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

import BigInt

/// The different types of request that can be generated
///
/// - receive: The requester wants to receive an amount of token
/// - send: The requester wants to send an amount of token
public enum TransactionRequestType: String, Codable {
    case receive
    case send
}

/// The status of the transaction request
///
/// - valid: The transaction request is valid and ready to be consumed
/// - expired: The transaction request is expired and can't be consumed
public enum TransactionRequestStatus: String, Decodable {
    case valid
    case expired
}

/// Represents a transaction request
public struct TransactionRequest {

    /// The unique identifier of the request
    public let id: String
    /// The type of the request (send of receive)
    public let type: TransactionRequestType
    /// The token to use for the request
    /// In the case of a type "send", this will be the token taken from the requester
    /// In the case of a type "receive" this will be the token received by the requester
    public let token: Token
    /// The amount of token to use for the transaction (down to subunit to unit)
    /// This amount needs to be either specified by the requester or the consumer
    public let amount: BigInt?
    /// The address from which to send or receive the tokens
    public let address: String
    /// The user that initiated the request
    public let user: User?
    /// The account that initiated the request
    public let account: Account?
    /// An id that can uniquely identify a transaction. Typically an order id from a provider.
    public let correlationId: String?
    /// The status of the request (valid or expired)
    public let status: TransactionRequestStatus
    /// The topic which can be listened in order to receive events regarding this request
    public let socketTopic: String
    /// A boolean indicating if the request needs a confirmation from the requester before being proceeded
    public let requireConfirmation: Bool
    /// The maximum number of time that this request can be consumed
    public let maxConsumptions: Int?
    /// The amount of time in milisecond during which a consumption is valid
    public let consumptionLifetime: Int?
    /// The date when the request will expire and not be consumable anymore
    public let expirationDate: Date?
    /// The reason why the request expired
    public let expirationReason: String?
    /// The creation date of the request
    public let createdAt: Date?
    /// The date when the request expired
    public let expiredAt: Date?
    /// Allow or not the consumer to override the amount specified in the request
    public let allowAmountOverride: Bool
    /// The maximum number of consumptions allowed per unique user
    public let maxConsumptionsPerUser: Int?
    /// An id that can be encoded in a QR code and be used to retrieve the request later
    public let formattedId: String
    /// Additional metadata for the request
    public let metadata: [String: Any]
    /// Additional encrypted metadata for the request
    public let encryptedMetadata: [String: Any]

}

extension TransactionRequest: Listenable {}

extension TransactionRequest: QREncodable {}

extension TransactionRequest: Decodable {

    private enum CodingKeys: String, CodingKey {
        case id
        case type
        case token
        case amount
        case address
        case user
        case account
        case correlationId = "correlation_id"
        case status
        case socketTopic = "socket_topic"
        case requireConfirmation = "require_confirmation"
        case maxConsumptions = "max_consumptions"
        case consumptionLifetime = "consumption_lifetime"
        case expirationDate = "expiration_date"
        case expirationReason = "expiration_reason"
        case createdAt = "created_at"
        case expiredAt = "expired_at"
        case allowAmountOverride = "allow_amount_override"
        case maxConsumptionsPerUser = "max_consumptions_per_user"
        case formattedId = "formatted_id"
        case metadata
        case encryptedMetadata = "encrypted_metadata"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        type = try container.decode(TransactionRequestType.self, forKey: .type)
        token = try container.decode(Token.self, forKey: .token)
        amount = try container.decodeIfPresent(BigInt.self, forKey: .amount)
        address = try container.decode(String.self, forKey: .address)
        user = try container.decodeIfPresent(User.self, forKey: .user)
        account = try container.decodeIfPresent(Account.self, forKey: .account)
        correlationId = try container.decodeIfPresent(String.self, forKey: .correlationId)
        status = try container.decode(TransactionRequestStatus.self, forKey: .status)
        socketTopic = try container.decode(String.self, forKey: .socketTopic)
        requireConfirmation = try container.decode(Bool.self, forKey: .requireConfirmation)
        maxConsumptions = try container.decodeIfPresent(Int.self, forKey: .maxConsumptions)
        consumptionLifetime = try container.decodeIfPresent(Int.self, forKey: .consumptionLifetime)
        expirationDate = try container.decodeIfPresent(Date.self, forKey: .expirationDate)
        expirationReason = try container.decodeIfPresent(String.self, forKey: .expirationReason)
        createdAt = try container.decode(Date.self, forKey: .createdAt)
        expiredAt = try container.decodeIfPresent(Date.self, forKey: .expiredAt)
        allowAmountOverride = try container.decode(Bool.self, forKey: .allowAmountOverride)
        maxConsumptionsPerUser = try container.decodeIfPresent(Int.self, forKey: .maxConsumptionsPerUser)
        formattedId = try container.decode(String.self, forKey: .formattedId)
        metadata = try container.decode([String: Any].self, forKey: .metadata)
        encryptedMetadata = try container.decode([String: Any].self, forKey: .encryptedMetadata)
    }

}

extension TransactionRequest: Retrievable {

    @discardableResult
    /// Generate a transaction request from the given TransactionRequestParams object
    ///
    /// - Parameters:
    ///   - client: An API client.
    ///             This client need to be initialized with a ClientConfiguration struct before being used.
    ///   - params: The TransactionRequestCreateParams object describing the transaction request to be made.
    ///   - callback: The closure called when the request is completed
    /// - Returns: An optional cancellable request.
    public static func create(using client: HTTPClient,
                              params: TransactionRequestCreateParams,
                              callback: @escaping TransactionRequest.RetrieveRequestCallback)
        -> TransactionRequest.RetrieveRequest? {
            return self.retrieve(using: client,
                                 endpoint: .transactionRequestCreate(params: params),
                                 callback: callback)
    }

    @discardableResult
    /// Retreive a transaction request from its formatted id
    ///
    /// - Parameters:
    ///   - client: An API client.
    ///             This client need to be initialized with a ClientConfiguration struct before being used.
    ///   - formattedId: The formatted id of the TransactionRequest to be retrived.
    ///   - callback: The closure called when the request is completed
    /// - Returns: An optional cancellable request.
    public static func get(using client: HTTPClient,
                           formattedId: String,
                           callback: @escaping TransactionRequest.RetrieveRequestCallback)
        -> TransactionRequest.RetrieveRequest? {
            let params = TransactionRequestGetParams(formattedId: formattedId)
            return self.retrieve(using: client,
                                 endpoint: .transactionRequestGet(params: params),
                                 callback: callback)
    }

}

extension TransactionRequest: Hashable {

    public var hashValue: Int {
        return self.id.hashValue
    }

    public static func == (lhs: TransactionRequest, rhs: TransactionRequest) -> Bool {
        return lhs.id == rhs.id
    }

}
