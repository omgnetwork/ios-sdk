//
//  TransactionConsumptionParamsTest.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 7/2/2018.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

import XCTest
@testable import OmiseGO

class TransactionConsumptionParamsTest: XCTestCase {

    func testInitCorrectlyWhenGivenAnAmountFromATransactionRequest() {

        let transactionRequest = StubGenerator.transactionRequest(amount: 1337)
        XCTAssertNotNil(TransactionConsumptionParams(transactionRequest: transactionRequest,
                                                     address: nil,
                                                     mintedTokenId: nil,
                                                     amount: nil,
                                                     idempotencyToken: "123",
                                                     correlationId: nil,
                                                     metadata: [:]))
    }

    func testFailInitWhenNotGivenAnAmount() {
        let transactionRequest = TransactionRequest(id: "0a8a4a98-794b-419e-b92d-514e83657e75",
                                                    type: .receive,
                                                    mintedToken: StubGenerator.mintedToken(),
                                                    amount: nil,
                                                    address: "3bfe0ff7-f43e-4ac6-bdf9-c4a290c40d0d",
                                                    correlationId: "31009545-db10-4287-82f4-afb46d9741d8",
                                                    status: .valid,
                                                    socketTopic: "",
                                                    requireConfirmation: true,
                                                    maxConsumptions: nil,
                                                    consumptionLifetime: nil,
                                                    expirationDate: nil,
                                                    expirationReason: nil,
                                                    expiredAt: nil,
                                                    allowAmountOverride: true,
                                                    metadata: [:])
        XCTAssertNil(TransactionConsumptionParams(transactionRequest: transactionRequest,
                                                  address: nil,
                                                  mintedTokenId: nil,
                                                  amount: nil,
                                                  idempotencyToken: "123",
                                                  correlationId: nil,
                                                  metadata: [:]))
    }

    func testInitCorrectlyWhenGivenAnAmount() {
        let transactionRequest = TransactionRequest(id: "0a8a4a98-794b-419e-b92d-514e83657e75",
                                                    type: .receive,
                                                    mintedToken: StubGenerator.mintedToken(),
                                                    amount: nil,
                                                    address: "3bfe0ff7-f43e-4ac6-bdf9-c4a290c40d0d",
                                                    correlationId: "31009545-db10-4287-82f4-afb46d9741d8",
                                                    status: .valid,
                                                    socketTopic: "",
                                                    requireConfirmation: true,
                                                    maxConsumptions: nil,
                                                    consumptionLifetime: nil,
                                                    expirationDate: nil,
                                                    expirationReason: nil,
                                                    expiredAt: nil,
                                                    allowAmountOverride: true,
                                                    metadata: [:])
        let params = TransactionConsumptionParams(transactionRequest: transactionRequest,
                                              address: nil,
                                              mintedTokenId: nil,
                                              amount: 3000,
                                              idempotencyToken: "123",
                                              correlationId: nil,
                                              metadata: [:])!
        XCTAssertEqual(params.amount, 3000)
    }

    func testAmountIsTakenFromAmountParamFirst() {
        let transactionRequest = StubGenerator.transactionRequest(amount: 1337)
        let params = TransactionConsumptionParams(transactionRequest: transactionRequest,
                                                  address: nil,
                                                  mintedTokenId: nil,
                                                  amount: 3000,
                                                  idempotencyToken: "123",
                                                  correlationId: nil,
                                                  metadata: [:])!
        XCTAssertEqual(params.amount, 3000)
    }

}
