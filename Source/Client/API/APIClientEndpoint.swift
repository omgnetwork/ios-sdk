//
//  APIClientEndpoint.swift
//  OmiseGO
//
//  Created by Mederic Petit on 9/10/2017.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

/// Represents a client api endpoint.
enum APIClientEndpoint: APIEndpoint {
    case getCurrentUser
    case getWallets
    case getSettings
    case getTransactions(params: TransactionListParams)
    case createTransaction(params: TransactionCreateParams)
    case transactionRequestCreate(params: TransactionRequestCreateParams)
    case transactionRequestGet(params: TransactionRequestGetParams)
    case transactionRequestConsume(params: TransactionConsumptionParams)
    case transactionConsumptionCancel(params: TransactionConsumptionCancellationParams)
    case transactionConsumptionApprove(params: TransactionConsumptionConfirmationParams)
    case transactionConsumptionReject(params: TransactionConsumptionConfirmationParams)
    case signup(params: SignupParams)
    case login(params: LoginParams)
    case logout

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
        case .transactionConsumptionCancel:
            return "/me.cancel_transaction_consumption"
        case .transactionConsumptionApprove:
            return "/me.approve_transaction_consumption"
        case .transactionConsumptionReject:
            return "/me.reject_transaction_consumption"
        case .signup:
            return "user.signup"
        case .login:
            return "user.login"
        case .logout:
            return "/me.logout"
        }
    }

    var task: HTTPTask {
        switch self {
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
        case let .transactionConsumptionCancel(parameters):
            return .requestParameters(parameters: parameters)
        case let .transactionConsumptionApprove(parameters):
            return .requestParameters(parameters: parameters)
        case let .transactionConsumptionReject(parameters):
            return .requestParameters(parameters: parameters)
        case let .signup(parameters):
            return .requestParameters(parameters: parameters)
        case let .login(parameters):
            return .requestParameters(parameters: parameters)
        default: return .requestPlain
        }
    }
}
