//
//  APIError.swift
//  OmiseGO
//
//  Created by Mederic Petit on 9/10/2560 BE.
//  Copyright © 2560 OmiseGO. All rights reserved.
//

import UIKit

/// Represents an API error
public struct APIError: OmiseGOObject, CustomDebugStringConvertible {

    /// The error code describing the error
    public let code: APIErrorCode
    /// The error message
    public let description: String

    public var debugDescription: String {
        return "Error: \(code.debugDescription) - \(description)"
    }

    public enum APIErrorCode: CustomDebugStringConvertible, Decodable {

        case other(String)

        init(code: String) {
            switch code {
            case let code:
                self = .other(code)
            }
        }

        public init(from decoder: Decoder) throws {
            self.init(code: try decoder.singleValueContainer().decode(String.self))
        }

        public var code: String {
            switch self {
            case .other(let code):
                return code
            }
        }

        public var debugDescription: String {
            switch self {
            case .other(let code):
                return code
            }
        }
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
