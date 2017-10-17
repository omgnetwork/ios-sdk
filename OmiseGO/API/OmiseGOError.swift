//
//  OmiseGOError.swift
//  OmiseGO
//
//  Created by Mederic Petit on 9/10/2560 BE.
//  Copyright © 2560 OmiseGO. All rights reserved.
//

import UIKit

/// Represents a SDK error
///
/// - unexpected: An unexpected error has occured
/// - configuration: A configuration error has occured
/// - api: An API error has occured
/// - other: Other types of errors
public enum OmiseGOError: Error {
    case unexpected(String)
    case configuration(String)
    case api(APIError)
    case other(Error)

    public var message: String {
        switch self {
        case .unexpected(let message):
            return "unexpected error: \(message)"
        case .configuration(let message):
            return "configuration error: \(message)"
        case .other(let err as DecodingError):
            return "Decoding Error: \(err.localizedDescription) - \(err.failureReason ?? "")"
        case .other(let err):
            return "I/O error: \(err.localizedDescription)"
        case .api(let err):
            return "(\(err.code)) \(err.message)"
        }
    }
}

extension OmiseGOError: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String { return self.message }
    public var debugDescription: String { return self.message }
}

extension OmiseGOError: LocalizedError {
    public var errorDescription: String {
        return self.message
    }
}
