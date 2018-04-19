//
//  TransactionRequest.swift
//  OmiseGO
//
//  Created by Mederic Petit on 5/2/2018.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

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
    /// The minted token for the request
    /// In the case of a type "send", this will be the token taken from the requester
    /// In the case of a type "receive" this will be the token received by the requester
    public let mintedToken: MintedToken
    /// The amount of minted token to use for the transaction (down to subunit to unit)
    /// This amount needs to be either specified by the requester or the consumer
    public let amount: Double?
    /// The address from which to send or receive the minted tokens
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
    /// The date when the request expired
    public let expiredAt: Date?
    /// Allow or not the consumer to override the amount specified in the request
    public let allowAmountOverride: Bool
    /// Additional metadata for the request
    public let metadata: [String: Any]

}

extension TransactionRequest: Listenable {}

extension TransactionRequest: Decodable {

    private enum CodingKeys: String, CodingKey {
        case id
        case type
        case mintedToken = "minted_token"
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
        case expiredAt = "expired_at"
        case allowAmountOverride = "allow_amount_override"
        case metadata
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        type = try container.decode(TransactionRequestType.self, forKey: .type)
        mintedToken = try container.decode(MintedToken.self, forKey: .mintedToken)
        amount = try container.decodeIfPresent(Double.self, forKey: .amount)
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
        expiredAt = try container.decodeIfPresent(Date.self, forKey: .expiredAt)
        allowAmountOverride = try container.decode(Bool.self, forKey: .allowAmountOverride)
        metadata = try container.decode([String: Any].self, forKey: .metadata)
    }

}

extension TransactionRequest {

    /// Generates an QR image containing the encded transaction request id
    ///
    /// - Parameter size: the desired image size
    /// - Returns: A QR image if the transaction request was successfuly encoded, nil otherwise.
    public func qrImage(withSize size: CGSize = CGSize(width: 200, height: 200)) -> UIImage? {
        guard let data = self.id.data(using: .isoLatin1) else { return nil }
        return QRGenerator.generateQRCode(fromData: data, outputSize: size)
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
    public static func generateTransactionRequest(using client: HTTPClient,
                                                  params: TransactionRequestCreateParams,
                                                  callback: @escaping TransactionRequest.RetrieveRequestCallback)
        -> TransactionRequest.RetrieveRequest? {
            return self.retrieve(using: client,
                                 endpoint: .transactionRequestCreate(params: params),
                                 callback: callback)
    }

    @discardableResult
    /// Retreive a transaction request from its id
    ///
    /// - Parameters:
    ///   - client: An API client.
    ///             This client need to be initialized with a ClientConfiguration struct before being used.
    ///   - id: The id of the TransactionRequest to be retrived.
    ///   - callback: The closure called when the request is completed
    /// - Returns: An optional cancellable request.
    public static func retrieveTransactionRequest(using client: HTTPClient,
                                                  id: String,
                                                  callback: @escaping TransactionRequest.RetrieveRequestCallback)
        -> TransactionRequest.RetrieveRequest? {
            let params = TransactionRequestGetParams(id: id)
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
