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
    case getAccounts(params: PaginatedListParams<Account>)
    case getTransactions(params: PaginatedListParams<Transaction>)
    case createTransaction(params: TransactionCreateParams)

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
        case .getAccounts:
            return "/account.all"
        case .getTransactions:
            return "/transaction.all"
        case .createTransaction:
            return "/transaction.create"
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
        case let .getAccounts(parameters):
            return .requestParameters(parameters: parameters)
        case let .getTransactions(parameters):
            return .requestParameters(parameters: parameters)
        case let .createTransaction(parameters):
            return .requestParameters(parameters: parameters)
        default:
            return .requestPlain
        }
    }
}
