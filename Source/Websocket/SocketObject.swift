//
//  SocketObject.swift
//  OmiseGO
//
//  Created by Mederic Petit on 9/3/18.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

struct GenericObject {
    let object: GenericObjectEnum
}

extension GenericObject: Decodable {
    private enum CodingKeys: String, CodingKey {
        case objectType = "object"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let objectType: String? = try container.decodeIfPresent(String.self, forKey: .objectType)
        guard let decodedObject = try GenericObjectEnum(objectType: objectType, decoder: decoder) else {
            throw OMGError.socketError(message: "Unknown object type")
        }
        self.object = decodedObject
    }
}

public enum WebsocketObject {
    case transactionConsumption(object: TransactionConsumption)
}

enum GenericObjectEnum {
    case transactionConsumption(object: TransactionConsumption)
    case error(error: OMGError)
    case other(object: [String: Any])
}

extension GenericObjectEnum {
    init?(objectType: String?, decoder: Decoder) throws {
        guard let objectType = objectType else {
            self = .other(object: [:])
            return
        }
        switch objectType {
        case "transaction_consumption":
            self = .transactionConsumption(object: try TransactionConsumption(from: decoder))
        default: self = .error(error: OMGError.socketError(message: "Invalid payload"))
        }
    }
}
