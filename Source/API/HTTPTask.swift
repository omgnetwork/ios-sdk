//
//  HTTPTask.swift
//  OmiseGO
//
//  Created by yuzushioh on 2018/05/11.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

/// Protocol for api parameters
public protocol APIParameters: Encodable {

    /// Returns idempotency token if parameters have one
    ///
    /// - Returns: idempotency token
    func getIdempotencyToken() -> String?
}

extension APIParameters {
    public func getIdempotencyToken() -> String? {
        return nil
    }

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
        case .requestParameters(let parameters):
            return parameters
        case .requestPlain:
            return nil
        }
    }

    /// An idempotency token required for task's request
    /// nil if tasks do not require a token
    public var idempotencyToken: String? {
        return self.parameters?.getIdempotencyToken()
    }

}
