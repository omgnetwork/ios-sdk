//
//  APIAdminEndpoint.swift
//  OmiseGO
//
//  Created by Mederic Petit on 9/10/2017.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

/// Represents an admin api endpoint.
enum APIAdminEndpoint: APIEndpoint {
    case login(params: LoginParams)
    case logout
    case getWallet(params: WalletGetParams)
    case getWalletsForUser(params: WalletListForUserParams)
    case getWalletsForAccount(params: WalletListForAccountParams)
    case getAccount(params: AccountGetParams)
    case getAccounts(params: PaginatedListParams<Account>)
    case getTransactions(params: PaginatedListParams<Transaction>)
    case createTransaction(params: TransactionCreateParams)
    case transactionRequestCreate(params: TransactionRequestCreateParams)
    case transactionRequestGet(params: TransactionRequestGetParams)
    case transactionRequestConsume(params: TransactionConsumptionParams)
    case transactionConsumptionCancel(params: TransactionConsumptionCancellationParams)
    case transactionConsumptionApprove(params: TransactionConsumptionConfirmationParams)
    case transactionConsumptionReject(params: TransactionConsumptionConfirmationParams)

    var path: String {
        switch self {
        case .login:
            return "/admin.login"
        case .logout:
            return "/me.logout"
        case .getWallet:
            return "/wallet.get"
        case .getWalletsForUser:
            return "/user.get_wallets"
        case .getWalletsForAccount:
            return "/account.get_wallets"
        case .getAccount:
            return "/account.get"
        case .getAccounts:
            return "/account.all"
        case .getTransactions:
            return "/transaction.all"
        case .createTransaction:
            return "/transaction.create"
        case .transactionRequestCreate:
            return "/transaction_request.create"
        case .transactionRequestGet:
            return "/transaction_request.get"
        case .transactionRequestConsume:
            return "/transaction_request.consume"
        case .transactionConsumptionCancel:
            return "/transaction_consumption.cancel"
        case .transactionConsumptionApprove:
            return "/transaction_consumption.approve"
        case .transactionConsumptionReject:
            return "/transaction_consumption.reject"
        }
    }

    var task: HTTPTask {
        switch self {
        case let .login(parameters):
            return .requestParameters(parameters: parameters)
        case let .getWallet(parameters):
            return .requestParameters(parameters: parameters)
        case let .getWalletsForUser(parameters):
            return .requestParameters(parameters: parameters)
        case let .getWalletsForAccount(parameters):
            return .requestParameters(parameters: parameters)
        case let .getAccount(parameters):
            return .requestParameters(parameters: parameters)
        case let .getAccounts(parameters):
            return .requestParameters(parameters: parameters)
        case let .getTransactions(parameters):
            return .requestParameters(parameters: parameters)
        case let .createTransaction(parameters):
            return .requestParameters(parameters: parameters)
        case let .transactionRequestCreate(parameters):
            return .requestParameters(parameters: parameters)
        case let .transactionRequestGet(parameters):
            return .requestParameters(parameters: parameters)
        case let .transactionRequestConsume(parameters):
            return .requestParameters(parameters: parameters)
        case let .transactionConsumptionApprove(parameters):
            return .requestParameters(parameters: parameters)
        case let .transactionConsumptionCancel(parameters):
            return .requestParameters(parameters: parameters)
        case let .transactionConsumptionReject(parameters):
            return .requestParameters(parameters: parameters)
        default:
            return .requestPlain
        }
    }
}
