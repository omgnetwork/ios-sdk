//
//  HTTPTask.swift
//  OmiseGO
//
//  Created by yuzushioh on 2018/05/11.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

/// Protocol for api parameters
public protocol APIParameters: Encodable {}

extension APIParameters {
    public func encodedPayload() throws -> Data {
        return try serialize(self)
    }
}

/// Represents an HTTP task.
enum HTTPTask {
    /// A request with no additional data.
    case requestPlain
    /// A requests body set with encoded parameters.
    case requestParameters(parameters: APIParameters)

    /// Parameters required for task's request
    /// nil if tasks do not require any parameters
    public var parameters: APIParameters? {
        switch self {
        case let .requestParameters(parameters):
            return parameters
        case .requestPlain:
            return nil
        }
    }
}
