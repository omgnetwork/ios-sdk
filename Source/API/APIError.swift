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
        case object
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
    case other(String)

    //swiftlint:disable:next cyclomatic_complexity
    init(code: String) {
        switch code {
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
        case let code:
            self = .other(code)
        }
    }

    public init(from decoder: Decoder) throws {
        self.init(code: try decoder.singleValueContainer().decode(String.self))
    }

    public var code: String {
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
        case .other(let code):
            return code
        }
    }
}

extension APIErrorCode: Hashable {

    public var hashValue: Int {
        return self.code.hashValue
    }

}

// MARK: Equatable

public func == (lhs: APIErrorCode, rhs: APIErrorCode) -> Bool {
    return lhs.code == rhs.code
}
