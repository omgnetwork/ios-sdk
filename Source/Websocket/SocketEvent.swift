//
//  SocketEvent.swift
//  OmiseGO
//
//  Created by Mederic Petit on 20/3/18.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

enum SocketEventSend: String, Encodable {
    case heartbeat
    case join = "phx_join"
    case leave = "phx_leave"
}

public enum SocketEvent: Decodable {
    case reply
    case error
    case close
    case transactionConsumptionRequest
    case transactionConsumptionFinalized
    case other(event: String)

    public var eventName: String {
        return self.rawValue
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let event = try container.decode(String.self)
        self = SocketEvent(rawValue: event)!
    }
}

extension SocketEvent: RawRepresentable {
    public typealias RawValue = String

    public init?(rawValue: String) {
        switch rawValue {
        case "phx_error": self = .error
        case "phx_close": self = .close
        case "phx_reply": self = .reply
        case "transaction_consumption_request": self = .transactionConsumptionRequest
        case "transaction_consumption_finalized": self = .transactionConsumptionFinalized
        default: self = .other(event: rawValue)
        }
    }

    public var rawValue: String {
        switch self {
        case .error: return "phx_error"
        case .close: return "phx_close"
        case .reply: return "phx_reply"
        case .transactionConsumptionRequest: return "transaction_consumption_request"
        case .transactionConsumptionFinalized: return "transaction_consumption_finalized"
        case let .other(event: event): return event
        }
    }
}

extension SocketEvent: Equatable {
    public static func == (lhs: SocketEvent, rhs: SocketEvent) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}
