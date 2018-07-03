//
//  APIEndpoint.swift
//  OmiseGO
//
//  Created by Mederic Petit on 9/10/2017.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

/// Represents an api endpoint.
enum APIEndpoint {
    case getCurrentUser
    case getWallets
    case getSettings
    case getTransactions(params: TransactionListParams)
    case createTransaction(params: TransactionCreateParams)
    case transactionRequestCreate(params: TransactionRequestCreateParams)
    case transactionRequestGet(params: TransactionRequestGetParams)
    case transactionRequestConsume(params: TransactionConsumptionParams)
    case transactionConsumptionApprove(params: TransactionConsumptionConfirmationParams)
    case transactionConsumptionReject(params: TransactionConsumptionConfirmationParams)
    case logout
    case custom(path: String, task: HTTPTask)

    var path: String {
        switch self {
        case .getCurrentUser:
            return "/me.get"
        case .getWallets:
            return "/me.get_wallets"
        case .getSettings:
            return "/me.get_settings"
        case .getTransactions:
            return "/me.get_transactions"
        case .createTransaction:
            return "/me.create_transaction"
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
            return "/me.logout"
        case .custom(let path, _):
            return path
        }
    }

    var task: HTTPTask {
        switch self {
        case .getCurrentUser, .getWallets, .getSettings, .logout: // Send no parameters
            return .requestPlain
        case let .createTransaction(parameters):
            return .requestParameters(parameters: parameters)
        case let .transactionRequestCreate(parameters):
            return .requestParameters(parameters: parameters)
        case let .transactionRequestGet(parameters):
            return .requestParameters(parameters: parameters)
        case let .transactionRequestConsume(parameters):
            return .requestParameters(parameters: parameters)
        case let .getTransactions(parameters):
            return .requestParameters(parameters: parameters)
        case let .transactionConsumptionApprove(parameters):
            return .requestParameters(parameters: parameters)
        case let .transactionConsumptionReject(parameters):
            return .requestParameters(parameters: parameters)
        case let .custom(_, task):
            return task
        }
    }
}
