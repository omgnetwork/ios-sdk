//
//  APIError.swift
//  OmiseGO
//
//  Created by Mederic Petit on 9/10/2017.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

/// Represents an API error
public struct APIError {

    /// The error code describing the error
    public let code: APIErrorCode
    /// The error message
    public let description: String

    public var localizedDescription: String {
        return self.description
    }

    /// Indicate if the error is an authorization error in which case you may want to refresh the authentication token
    public func isAuthorizationError() -> Bool {
        switch self.code {
        case .accessTokenExpired, .accessTokenNotFound, .invalidAPIKey: return true
        default: return false
        }
    }

}

extension APIError: CustomDebugStringConvertible {

    public var debugDescription: String {
        return "Error: \(code) \(description)"
    }

}

extension APIError: Error {}

extension APIError: Decodable {

    private enum CodingKeys: String, CodingKey {
        case code
        case description
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        code = try container.decode(APIErrorCode.self, forKey: .code)
        description = try container.decode(String.self, forKey: .description)
    }

}

// Represents the different API error codes
public enum APIErrorCode: Decodable {

    case invalidParameters
    case invalidVersion
    case permissionError
    case endPointNotFound
    case invalidAPIKey
    case internalServerError
    case unknownServerError
    case accessTokenNotFound
    case accessTokenExpired
    case missingIdempotencyToken
    case sameAddress
    case websocketError
    case requestExpired
    case maxConsumptionsReached
    case notOwnerOfTransactionConsumption
    case invalidMintedTokenForTransactionConsumption
    case forbiddenChannel
    case channelNotFound
    case other(String)

    public init(from decoder: Decoder) throws {
        self.init(rawValue: try decoder.singleValueContainer().decode(String.self))!
    }

    public var code: String {
        return self.rawValue
    }
}

extension APIErrorCode: RawRepresentable {

    //swiftlint:disable:next cyclomatic_complexity
    public init?(rawValue: String) {
        switch rawValue {
        case "client:invalid_parameter":
            self = .invalidParameters
        case "client:invalid_version":
            self = .invalidVersion
        case "client:permission_error":
            self = .permissionError
        case "client:endpoint_not_found":
            self = .endPointNotFound
        case "client:invalid_api_key":
            self = .invalidAPIKey
        case "server:internal_server_error":
            self = .internalServerError
        case "server:unknown_error":
            self = .unknownServerError
        case "user:access_token_not_found":
            self = .accessTokenNotFound
        case "user:access_token_expired":
            self = .accessTokenExpired
        case "client:no_idempotency_token_provided":
            self = .missingIdempotencyToken
        case "transaction:same_address":
            self = .sameAddress
        case "websocket:connect_error":
            self = .websocketError
        case "request:expired":
            self = .requestExpired
        case "request:max_consumptions_reached":
            self = .maxConsumptionsReached
        case "transaction_consumption:not_owner":
            self = .notOwnerOfTransactionConsumption
        case "transaction_consumption:invalid_minted_token":
            self = .invalidMintedTokenForTransactionConsumption
        case "websocket:forbidden_channel":
            self = .forbiddenChannel
        case "websocket:channel_not_found":
            self = .channelNotFound
        case let code:
            self = .other(code)
        }
    }

    public var rawValue: String {
        switch self {
        case .invalidParameters:
            return "client:invalid_parameter"
        case .invalidVersion:
            return "client:invalid_version"
        case .permissionError:
            return "client:permission_error"
        case .endPointNotFound:
            return "client:endpoint_not_found"
        case .invalidAPIKey:
            return "client:invalid_api_key"
        case .internalServerError:
            return "server:internal_server_error"
        case .unknownServerError:
            return "server:unknown_error"
        case .accessTokenNotFound:
            return "user:access_token_not_found"
        case .accessTokenExpired:
            return "user:access_token_expired"
        case .missingIdempotencyToken:
            return "client:no_idempotency_token_provided"
        case .sameAddress:
            return "transaction:same_address"
        case .websocketError:
            return "websocket:connect_error"
        case .requestExpired:
            return "request:expired"
        case .maxConsumptionsReached:
            return "request:max_consumptions_reached"
        case .notOwnerOfTransactionConsumption:
            return "transaction_consumption:not_owner"
        case .invalidMintedTokenForTransactionConsumption:
            return "transaction_consumption:invalid_minted_token"
        case .forbiddenChannel:
            return "websocket:forbidden_channel"
        case .channelNotFound:
            return "websocket:channel_not_found"
        case .other(let code):
            return code
        }
    }

    public typealias RawValue = String

}

extension APIErrorCode: Hashable {

    public var hashValue: Int {
        return self.code.hashValue
    }

    public static func == (lhs: APIErrorCode, rhs: APIErrorCode) -> Bool {
        return lhs.code == rhs.code
    }

}
