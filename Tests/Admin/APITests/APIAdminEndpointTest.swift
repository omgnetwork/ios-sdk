//
//  APIAdminEndpointTest.swift
//  Tests
//
//  Created by Mederic Petit on 14/9/2018.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

@testable import OmiseGO
import XCTest

class APIAdminEndpointTest: XCTestCase {
    let validLoginParams = LoginParams(email: "email@example.com", password: "password")
    let validWalletGetParams = WalletGetParams(address: "123")
    let validWalletListForUserParams =
        WalletListForUserParams(paginatedListParams: PaginatedListParams<Wallet>(page: 1,
                                                                                 perPage: 1,
                                                                                 sortBy: .address,
                                                                                 sortDirection: .ascending),
                                userId: "123")
    let validWalletListForAccountParams =
        WalletListForAccountParams(paginatedListParams: PaginatedListParams<Wallet>(page: 1,
                                                                                    perPage: 1,
                                                                                    sortBy: .address,
                                                                                    sortDirection: .ascending),
                                   accountId: "123",
                                   owned: false)

    func testPath() {
        XCTAssertEqual(APIAdminEndpoint.login(params: self.validLoginParams).path, "/admin.login")
        XCTAssertEqual(APIAdminEndpoint.logout.path, "/me.logout")
        XCTAssertEqual(APIAdminEndpoint.getWallet(params: self.validWalletGetParams).path, "/wallet.get")
        XCTAssertEqual(APIAdminEndpoint.getWalletsForUser(params: self.validWalletListForUserParams).path, "/user.get_wallets")
        XCTAssertEqual(APIAdminEndpoint.getWalletsForAccount(params: self.validWalletListForAccountParams).path, "/account.get_wallets")
    }

    func testTask() {
        switch APIClientEndpoint.login(params: self.validLoginParams).task {
        case .requestParameters: break
        default: XCTFail("Wrong task")
        }
        switch APIAdminEndpoint.logout.task {
        case .requestPlain: break
        default: XCTFail("Wrong task")
        }
        switch APIAdminEndpoint.getWallet(params: self.validWalletGetParams).task {
        case .requestParameters: break
        default: XCTFail("Wrong task")
        }
        switch APIAdminEndpoint.getWalletsForUser(params: self.validWalletListForUserParams).task {
        case .requestParameters: break
        default: XCTFail("Wrong task")
        }
        switch APIAdminEndpoint.getWalletsForAccount(params: self.validWalletListForAccountParams).task {
        case .requestParameters: break
        default: XCTFail("Wrong task")
        }
    }
}
