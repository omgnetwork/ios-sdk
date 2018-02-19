//
//  TransactionRequest.swift
//  OmiseGO
//
//  Created by Mederic Petit on 5/2/2561 BE.
//  Copyright © 2561 OmiseGO. All rights reserved.
//
// swiftlint:disable identifier_name

/// The different types of request that can be generated
///
/// - receive: The initiator wants to receive a specified token
public enum TransactionRequestType: String, Codable {
    case receive
}

/// The status of the transaction request
///
/// - valid: The transaction request is valid and ready to be consumed
/// - expired: The transaction request is expired and can't be consumed
public enum TransactionRequestStatus: String, Codable {
    case valid
    case expired
}

/// Represents a transaction request
public struct TransactionRequest: Codable {

    public let id: String
    public let type: TransactionRequestType
    public let mintedTokenId: String
    public let amount: Double?
    public let address: String?
    public let correlationId: String?
    public let status: TransactionRequestStatus

    private enum CodingKeys: String, CodingKey {
        case id
        case type
        case mintedTokenId = "token_id"
        case amount
        case address
        case correlationId = "correlation_id"
        case status
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(type, forKey: .type)
        try container.encode(mintedTokenId, forKey: .mintedTokenId)
        try container.encode(amount, forKey: .amount)
        try container.encode(address, forKey: .address)
        try container.encode(status, forKey: .status)
    }

}

extension TransactionRequest {

    /// Generates an QR image containing the encded transaction request id
    ///
    /// - Parameter size: the desired image size
    /// - Returns: A QR image if the transaction request was successfuly encoded, nil otherwise.
    public func qrImage(withSize size: CGSize = CGSize(width: 200, height: 200)) -> UIImage? {
        guard let data = self.id.data(using: .isoLatin1) else { return nil }
        return QRCode.generateQRCode(fromData: data, outputSize: size)
    }

}

extension TransactionRequest: Retrievable {

    @discardableResult
    /// Generate a transaction request from the given TransactionRequestParams object
    ///
    /// - Parameters:
    ///   - client: An API client.
    ///             This client need to be initialized with a OMGConfiguration struct before being used.
    ///   - params: The TransactionRequestCreateParams object describing the transaction request to be made.
    ///   - callback: The closure called when the request is completed
    /// - Returns: An optional cancellable request.
    public static func generateTransactionRequest(using client: OMGClient,
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
    ///             This client need to be initialized with a OMGConfiguration struct before being used.
    ///   - id: The id of the TransactionRequest to be retrived.
    ///   - callback: The closure called when the request is completed
    /// - Returns: An optional cancellable request.
    public static func retrieveTransactionRequest(using client: OMGClient,
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

}

// MARK: Equatable

public func == (lhs: TransactionRequest, rhs: TransactionRequest) -> Bool {
    return lhs.id == rhs.id
}
