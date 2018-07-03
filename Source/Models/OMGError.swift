//
//  OMGError.swift
//  OmiseGO
//
//  Created by Mederic Petit on 9/10/2017.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

/// Represents a SDK error
///
/// - unexpected: An unexpected error has occured
/// - configuration: A configuration error has occured
/// - api: An API error has occured
/// - other: Other types of errors
public enum OMGError: Error {
    case unexpected(message: String)
    case configuration(message: String)
    case api(apiError: APIError)
    case socketError(message: String)
    case decoding(underlyingError: DecodingError)
    case other(error: Error)

    public var message: String {
        switch self {
        case let .unexpected(message):
            return "unexpected error: \(message)"
        case let .configuration(message):
            return "configuration error: \(message)"
        case let .other(error):
            return "I/O error: \(error.localizedDescription)"
        case let .socketError(message):
            return "socket error: \(message)"
        case let .decoding(underlyingError: error):
            switch error {
            case let .dataCorrupted(context):
                return "decoding error: \(context.debugDescription)"
            case let .keyNotFound(_, context):
                return "decoding error: \(context.debugDescription)"
            case let .typeMismatch(_, context):
                return "decoding error: \(context.debugDescription)"
            case let .valueNotFound(_, context):
                return "decoding error: \(context.debugDescription)"
            }

        case let .api(error):
            return error.description
        }
    }

    public var localizedDescription: String {
        return self.message
    }
}

extension OMGError: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String { return self.message }
    public var debugDescription: String { return self.message }
}

extension OMGError: LocalizedError {
    public var errorDescription: String? { return self.message }
}

extension OMGError: Equatable {
    public static func == (lhs: OMGError, rhs: OMGError) -> Bool {
        switch (lhs, rhs) {
        case let (.unexpected(message: lhsMessage), .unexpected(message: rhsMessage)): return lhsMessage == rhsMessage
        case let (.configuration(message: lhsMessage), .configuration(message: rhsMessage)): return lhsMessage == rhsMessage
        case let (.api(apiError: lhsError), .api(apiError: rhsError)): return lhsError == rhsError
        case let (.socketError(message: lhsMessage), .socketError(message: rhsMessage)): return lhsMessage == rhsMessage
        default: return false
        }
    }
}
