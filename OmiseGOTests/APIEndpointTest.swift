//
//  APIEndpointTest.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 14/2/2561 BE.
//  Copyright © 2561 OmiseGO. All rights reserved.
//

import XCTest
@testable import OmiseGO

class APIEndpointTest: XCTestCase {

    let validTransactionConsumeParams = StubGenerator.transactionConsumeParams()
    let validTransactionCreateParams = StubGenerator.transactionRequestCreateParams()
    let validTransactionGetParams = StubGenerator.transactionRequestGetParams()

    func testPath() {
        XCTAssertEqual(APIEndpoint.getCurrentUser.path, "/me.get")
        XCTAssertEqual(APIEndpoint.getAddresses.path, "/me.list_balances")
        XCTAssertEqual(APIEndpoint.getSettings.path, "/me.get_settings")
        XCTAssertEqual(APIEndpoint.transactionRequestCreate(params: self.validTransactionCreateParams).path,
                       "/me.create_transaction_request")
        XCTAssertEqual(APIEndpoint.transactionRequestGet(params: self.validTransactionGetParams).path,
                       "/me.get_transaction_request")
        XCTAssertEqual(APIEndpoint.transactionRequestConsume(params: self.validTransactionConsumeParams).path,
                       "/me.consume_transaction_request")
        XCTAssertEqual(APIEndpoint.logout.path, "/logout")
    }

    //swiftlint:disable:next cyclomatic_complexity
    func testTask() {
        switch APIEndpoint.getCurrentUser.task {
        case .requestPlain: break
        default: XCTFail("Wrong task")
        }
        switch APIEndpoint.getAddresses.task {
        case .requestPlain: break
        default: XCTFail("Wrong task")
        }
        switch APIEndpoint.getSettings.task {
        case .requestPlain: break
        default: XCTFail("Wrong task")
        }
        switch APIEndpoint.logout.task {
        case .requestPlain: break
        default: XCTFail("Wrong task")
        }
        switch APIEndpoint.transactionRequestCreate(params: self.validTransactionCreateParams).task {
        case .requestParameters: break
        default: XCTFail("Wrong task")
        }
        switch APIEndpoint.transactionRequestGet(params: self.validTransactionGetParams).task {
        case .requestParameters: break
        default: XCTFail("Wrong task")
        }
        switch APIEndpoint.transactionRequestConsume(params: self.validTransactionConsumeParams).task {
        case .requestParameters: break
        default: XCTFail("Wrong task")
        }
    }

    func testAdditionalHeaders() {
        XCTAssertNil(APIEndpoint.getCurrentUser.additionalHeaders)
        XCTAssertNil(APIEndpoint.getAddresses.additionalHeaders)
        XCTAssertNil(APIEndpoint.getSettings.additionalHeaders)
        XCTAssertNil(APIEndpoint.logout.additionalHeaders)
        XCTAssertNil(APIEndpoint.transactionRequestCreate(params: self.validTransactionCreateParams).additionalHeaders)
        XCTAssertNil(APIEndpoint.transactionRequestGet(params: self.validTransactionGetParams).additionalHeaders)
        XCTAssertEqual(
            APIEndpoint.transactionRequestConsume(params: self.validTransactionConsumeParams).additionalHeaders!,
            ["Idempotency-Token": self.validTransactionConsumeParams.idempotencyToken])
    }

    func testMakeURL() {
        XCTAssertNil(APIEndpoint.custom(path: "/example", task: .requestPlain).makeURL(withBaseURL: "not a url"))
        XCTAssertEqual(APIEndpoint.custom(path: "/example",
                                          task: .requestPlain).makeURL(withBaseURL: "https://example.com"),
                       URL(string: "https://example.com/example"))
    }
}
