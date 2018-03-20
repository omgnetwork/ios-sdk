//
//  TransactionRequestParams.swift
//  OmiseGO
//
//  Created by Mederic Petit on 5/2/2018.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

/// Represents a structure used to generate a transaction request
public struct TransactionRequestCreateParams {

    /// The type of transaction to be generated
    public let type: TransactionRequestType
    /// The id of the desired token
    public let mintedTokenId: String
    /// The amount of token to receive.
    /// This amount can be either inputted when generating or consuming a transaction request.
    public let amount: Double?
    /// The address specifying where the transaction should be sent to.
    /// If not specified, the current user's primary address will be used.
    public let address: String?
    /// An id that can uniquely identify a transaction. Typically an order id from a provider.
    public let correlationId: String?

    public init(type: TransactionRequestType,
                mintedTokenId: String,
                amount: Double?,
                address: String?,
                correlationId: String?) {
        self.type = type
        self.mintedTokenId = mintedTokenId
        self.amount = amount
        self.address = address
        self.correlationId = correlationId
    }

}

extension TransactionRequestCreateParams: Parametrable {

    private enum CodingKeys: String, CodingKey {
        case type
        case mintedTokenId = "token_id"
        case amount
        case address
        case correlationId = "correlation_id"
    }

    func encodedPayload() -> Data? {
        return try? JSONEncoder().encode(self)
    }

    // Custom encoding as we need to encode amount event if nil
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encode(mintedTokenId, forKey: .mintedTokenId)
        try container.encode(amount, forKey: .amount)
        try container.encode(address, forKey: .address)
        try container.encode(correlationId, forKey: .correlationId)
    }

}

/// Represents a structure used to retrieve a transaction request from its id
struct TransactionRequestGetParams: Parametrable {

    let id: String

    func encodedPayload() -> Data? {
        return try? JSONEncoder().encode(self)
    }

}
