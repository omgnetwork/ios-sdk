//
//  APIClientEndpointTest.swift
//  Tests
//
//  Created by Mederic Petit on 14/2/2018.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

@testable import OmiseGO
import XCTest

class APIClientEndpointTest: XCTestCase {
    let validTransactionConsumptionParams = StubGenerator.transactionConsumptionParams()
    let validTransactionCreateParams = StubGenerator.transactionRequestCreateParams()
    let validTransactionGetParams = StubGenerator.transactionRequestGetParams()
    let validTransactionListParams = StubGenerator.transactionListParams()
    let validResetPasswordParams = StubGenerator.resetPasswordParams()
    let validUpdatePasswordParams = StubGenerator.updatePasswordParams()

    func testPath() {
        XCTAssertEqual(APIClientEndpoint.getCurrentUser.path, "/me.get")
        XCTAssertEqual(APIClientEndpoint.getWallets.path, "/me.get_wallets")
        XCTAssertEqual(APIClientEndpoint.getSettings.path, "/me.get_settings")
        XCTAssertEqual(APIClientEndpoint.getTransactions(params: self.validTransactionListParams).path,
                       "/me.get_transactions")
        XCTAssertEqual(APIClientEndpoint.transactionRequestCreate(params: self.validTransactionCreateParams).path,
                       "/me.create_transaction_request")
        XCTAssertEqual(APIClientEndpoint.transactionRequestGet(params: self.validTransactionGetParams).path,
                       "/me.get_transaction_request")
        XCTAssertEqual(APIClientEndpoint.transactionRequestConsume(params: self.validTransactionConsumptionParams).path,
                       "/me.consume_transaction_request")
        XCTAssertEqual(APIClientEndpoint.resetPassword(params: self.validResetPasswordParams).path,
                       "/user.reset_password")
        XCTAssertEqual(APIClientEndpoint.updatePassword(params: self.validUpdatePasswordParams).path,
                       "/user.update_password")
        XCTAssertEqual(APIClientEndpoint.logout.path, "/me.logout")
    }

    func testTask() {
        switch APIClientEndpoint.getCurrentUser.task {
        case .requestPlain: break
        default: XCTFail("Wrong task")
        }
        switch APIClientEndpoint.getWallets.task {
        case .requestPlain: break
        default: XCTFail("Wrong task")
        }
        switch APIClientEndpoint.getSettings.task {
        case .requestPlain: break
        default: XCTFail("Wrong task")
        }
        switch APIClientEndpoint.getTransactions(params: self.validTransactionListParams).task {
        case .requestParameters: break
        default: XCTFail("Wrong task")
        }
        switch APIClientEndpoint.logout.task {
        case .requestPlain: break
        default: XCTFail("Wrong task")
        }
        switch APIClientEndpoint.transactionRequestCreate(params: self.validTransactionCreateParams).task {
        case .requestParameters: break
        default: XCTFail("Wrong task")
        }
        switch APIClientEndpoint.transactionRequestGet(params: self.validTransactionGetParams).task {
        case .requestParameters: break
        default: XCTFail("Wrong task")
        }
        switch APIClientEndpoint.resetPassword(params: self.validResetPasswordParams).task {
        case .requestParameters: break
        default: XCTFail("Wrong task")
        }
        switch APIClientEndpoint.updatePassword(params: self.validUpdatePasswordParams).task {
        case .requestParameters: break
        default: XCTFail("Wrong task")
        }
        switch APIClientEndpoint.transactionRequestConsume(params: self.validTransactionConsumptionParams).task {
        case .requestParameters: break
        default: XCTFail("Wrong task")
        }
    }
}
