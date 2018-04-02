//
//  APIEndpoint.swift
//  OmiseGO
//
//  Created by Mederic Petit on 9/10/2017.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

protocol Parametrable: Encodable {}

extension Parametrable {
    func encodedPayload() throws -> Data {
        return try serialize(self)
    }
}

/// Represents an HTTP task.
enum Task {
    /// A request with no additional data.
    case requestPlain
    /// A requests body set with encoded parameters.
    case requestParameters(parameters: Parametrable)
}

enum APIEndpoint {

    case getCurrentUser
    case getAddresses
    case getSettings
    case getTransactions(params: TransactionListParams)
    case transactionRequestCreate(params: TransactionRequestCreateParams)
    case transactionRequestGet(params: TransactionRequestGetParams)
    case transactionRequestConsume(params: TransactionConsumptionParams)
    case transactionConsumptionApprove(params: TransactionConsumptionConfirmationParams)
    case transactionConsumptionReject(params: TransactionConsumptionConfirmationParams)
    case logout
    case custom(path: String, task: Task)

    var path: String {
        switch self {
        case .getCurrentUser:
            return "/me.get"
        case .getAddresses:
            return "/me.list_balances"
        case .getSettings:
            return "/me.get_settings"
        case .getTransactions:
            return "/me.list_transactions"
        case .transactionRequestCreate:
            return "/me.create_transaction_request"
        case .transactionRequestGet:
            return "/me.get_transaction_request"
        case .transactionRequestConsume:
            return "/me.consume_transaction_request"
        case .transactionConsumptionApprove:
            return "/me.approve_transaction_consumption"
        case .transactionConsumptionReject:
            return "/me.reject_transaction_consumption"
        case .logout:
            return "/logout"
        case .custom(let path, _):
            return path
        }
    }

    var task: Task {
        switch self {
        case .getCurrentUser, .getAddresses, .getSettings, .logout: // Send no parameters
            return .requestPlain
        case .transactionRequestCreate(params: let params):
            return .requestParameters(parameters: params)
        case .transactionRequestGet(params: let params):
            return .requestParameters(parameters: params)
        case .transactionRequestConsume(params: let params):
            return .requestParameters(parameters: params)
        case .getTransactions(params: let params):
            return .requestParameters(parameters: params)
        case .transactionConsumptionApprove(params: let params):
            return .requestParameters(parameters: params)
        case .transactionConsumptionReject(params: let params):
            return .requestParameters(parameters: params)
        case .custom(_, let task):
            return task
        }
    }

    var additionalHeaders: [String: String]? {
        switch self {
        case .transactionRequestConsume(params: let params):
            return ["Idempotency-Token": params.idempotencyToken]
        default: return nil
        }
    }

    func makeURL(withBaseURL baseURL: String) -> URL? {
        guard let url = URL(string: baseURL) else {
            omiseGOWarn("Base url is not a valid URL!")
            return nil
        }
        return url.appendingPathComponent(self.path)
    }
}
