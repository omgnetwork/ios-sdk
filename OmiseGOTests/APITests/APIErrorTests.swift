//
//  APIErrorTests.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 7/3/18.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

import XCTest
@testable import OmiseGO

class APIErrorTests: XCTestCase {

    func testLocalizedDescription() {
        let error = APIError.init(code: .invalidParameters, description: "error")
        XCTAssertEqual(error.localizedDescription, "error")
    }

    func testIsAuthorizationError() {
        XCTAssertTrue(APIError.init(code: .accessTokenExpired, description: "").isAuthorizationError())
        XCTAssertTrue(APIError.init(code: .accessTokenNotFound, description: "").isAuthorizationError())
        XCTAssertTrue(APIError.init(code: .invalidAPIKey, description: "").isAuthorizationError())
        XCTAssertFalse(APIError.init(code: .unknownServerError, description: "").isAuthorizationError())
    }

    func testDebugDescription() {
        let error = APIError.init(code: .accessTokenExpired, description: "description")
        XCTAssertEqual(error.debugDescription, "Error: accessTokenExpired description")
    }

}

class APIErrorCodeTests: XCTestCase {

    func testAPIErrorCodeInit() {
        XCTAssertEqual(APIErrorCode(rawValue: "client:invalid_parameter"),
                       APIErrorCode.invalidParameters)
        XCTAssertEqual(APIErrorCode(rawValue: "client:invalid_version"),
                       APIErrorCode.invalidVersion)
        XCTAssertEqual(APIErrorCode(rawValue: "client:permission_error"),
                       APIErrorCode.permissionError)
        XCTAssertEqual(APIErrorCode(rawValue: "client:endpoint_not_found"),
                       APIErrorCode.endPointNotFound)
        XCTAssertEqual(APIErrorCode(rawValue: "client:invalid_api_key"),
                       APIErrorCode.invalidAPIKey)
        XCTAssertEqual(APIErrorCode(rawValue: "server:internal_server_error"),
                       APIErrorCode.internalServerError)
        XCTAssertEqual(APIErrorCode(rawValue: "server:unknown_error"),
                       APIErrorCode.unknownServerError)
        XCTAssertEqual(APIErrorCode(rawValue: "user:access_token_not_found"),
                       APIErrorCode.accessTokenNotFound)
        XCTAssertEqual(APIErrorCode(rawValue: "user:access_token_expired"),
                       APIErrorCode.accessTokenExpired)
        XCTAssertEqual(APIErrorCode(rawValue: "client:no_idempotency_token_provided"),
                       APIErrorCode.missingIdempotencyToken)
        XCTAssertEqual(APIErrorCode(rawValue: "transaction:same_address"),
                       APIErrorCode.transactionSameAddress)
        XCTAssertEqual(APIErrorCode(rawValue: "transaction:insufficient_funds"),
                       APIErrorCode.transactionInsufficientFunds)
        XCTAssertEqual(APIErrorCode(rawValue: "websocket:connect_error"),
                       APIErrorCode.websocketError)
        XCTAssertEqual(APIErrorCode(rawValue: "transaction_request:expired"),
                       APIErrorCode.requestExpired)
        XCTAssertEqual(APIErrorCode(rawValue: "transaction_request:max_consumptions_reached"),
                       APIErrorCode.maxConsumptionsReached)
        XCTAssertEqual(APIErrorCode(rawValue: "transaction_request:max_consumptions_per_user_reached"),
                       APIErrorCode.maxConsumptionsPerUserReached)
        XCTAssertEqual(APIErrorCode(rawValue: "transaction_consumption:not_owner"),
                       APIErrorCode.notOwnerOfTransactionConsumption)
        XCTAssertEqual(APIErrorCode(rawValue: "transaction_consumption:invalid_minted_token"),
                       APIErrorCode.invalidMintedTokenForTransactionConsumption)
        XCTAssertEqual(APIErrorCode(rawValue: "transaction_consumption:expired"),
                       APIErrorCode.transactionConsumptionExpired)
        XCTAssertEqual(APIErrorCode(rawValue: "transaction_consumption:unfinalized"),
                       APIErrorCode.transactionConsumptionUnfinalized)
        XCTAssertEqual(APIErrorCode(rawValue: "websocket:forbidden_channel"),
                       APIErrorCode.forbiddenChannel)
        XCTAssertEqual(APIErrorCode(rawValue: "websocket:channel_not_found"),
                       APIErrorCode.channelNotFound)
        XCTAssertEqual(APIErrorCode(rawValue: "an other code"),
                       APIErrorCode.other("an other code"))
    }

    func testEquatable() {
        let error1 = APIErrorCode(rawValue: "client:invalid_parameter")
        let error2 = APIErrorCode(rawValue: "client:invalid_parameter")
        let error3 = APIErrorCode(rawValue: "client:invalid_version")
        XCTAssertEqual(error1, error2)
        XCTAssertNotEqual(error1, error3)
    }

    func testHashable() {
        let error1 = APIErrorCode(rawValue: "client:invalid_parameter")!
        let error2 = APIErrorCode(rawValue: "client:invalid_parameter")!
        let set: Set<APIErrorCode> = [error1, error2]
        XCTAssertEqual(error1.hashValue, "client:invalid_parameter".hashValue)
        XCTAssertEqual(set.count, 1)
    }

}
