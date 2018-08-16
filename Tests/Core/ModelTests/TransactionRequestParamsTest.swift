//
//  TransactionRequestParamsTest.swift
//  Tests
//
//  Created by Mederic Petit on 21/3/18.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

import OmiseGO
import XCTest

class TransactionRequestParamsTest: XCTestCase {
    func testInitCorrectlyWithAmountAndWithoutAllowingAmountOverride() {
        let transactionRequestParams =
            TransactionRequestCreateParams(type: .receive,
                                           tokenId: "BTC:861020af-17b6-49ee-a0cb-661a4d2d1f95",
                                           amount: 1337,
                                           address: "3b7f1c68-e3bd-4f8f-9916-4af19be95d00",
                                           correlationId: "31009545-db10-4287-82f4-afb46d9741d8",
                                           requireConfirmation: true,
                                           maxConsumptions: 1,
                                           consumptionLifetime: 1000,
                                           expirationDate: Date(timeIntervalSince1970: 0),
                                           allowAmountOverride: false,
                                           maxConsumptionsPerUser: nil,
                                           metadata: [:])
        XCTAssertNotNil(transactionRequestParams)
    }

    func testInitCorrectlyWithoutAmountAndWithAllowingAmountOverride() {
        let transactionRequestParams =
            TransactionRequestCreateParams(type: .receive,
                                           tokenId: "BTC:861020af-17b6-49ee-a0cb-661a4d2d1f95",
                                           amount: nil,
                                           address: "3b7f1c68-e3bd-4f8f-9916-4af19be95d00",
                                           correlationId: "31009545-db10-4287-82f4-afb46d9741d8",
                                           requireConfirmation: true,
                                           maxConsumptions: 1,
                                           consumptionLifetime: 1000,
                                           expirationDate: Date(timeIntervalSince1970: 0),
                                           allowAmountOverride: true,
                                           maxConsumptionsPerUser: nil,
                                           metadata: [:])
        XCTAssertNotNil(transactionRequestParams)
    }

    func testFailsToInitWithoutAmountAndWithoutAllowingAmountOverride() {
        let transactionRequestParams =
            TransactionRequestCreateParams(type: .receive,
                                           tokenId: "BTC:861020af-17b6-49ee-a0cb-661a4d2d1f95",
                                           amount: nil,
                                           address: "3b7f1c68-e3bd-4f8f-9916-4af19be95d00",
                                           correlationId: "31009545-db10-4287-82f4-afb46d9741d8",
                                           requireConfirmation: true,
                                           maxConsumptions: 1,
                                           consumptionLifetime: 1000,
                                           expirationDate: Date(timeIntervalSince1970: 0),
                                           allowAmountOverride: false,
                                           maxConsumptionsPerUser: nil,
                                           metadata: [:])
        XCTAssertNil(transactionRequestParams)
    }
}
