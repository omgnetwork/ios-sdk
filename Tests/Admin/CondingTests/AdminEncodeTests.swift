//
//  AdminEncodeTests.swift
//  Tests
//
//  Created by Mederic Petit on 8/10/18.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

import BigInt
@testable import OmiseGO
import XCTest

class AdminEncodeTests: XCTestCase {
    var encoder: JSONEncoder!

    override func setUp() {
        super.setUp()
        let jsonEncoder = JSONEncoder()
        jsonEncoder.dateEncodingStrategy = .custom({ try dateEncodingStrategy(date: $0, encoder: $1) })
        if #available(iOS 11.0, *) {
            jsonEncoder.outputFormatting = .sortedKeys
        }
        self.encoder = jsonEncoder
    }

    func testGetWalletParamsEncoding() {
        do {
            let walletParams = WalletGetParams(address: "123")
            let encodedData = try self.encoder.encode(walletParams)
            let encodedPayload = try! walletParams.encodedPayload()
            XCTAssertEqual(encodedData, encodedPayload)
            XCTAssertEqual(String(data: encodedData, encoding: .utf8)!, """
                {
                    "address":"123"
                }
            """.uglifiedEncodedString())
        } catch let thrownError {
            XCTFail(thrownError.localizedDescription)
        }
    }

    func testWalletListForUserParamsEncoding() {
        do {
            let walletParams = WalletListForUserParams(
                paginatedListParams: StubGenerator.paginatedListParams(
                    searchTerm: "test",
                    sortBy: .address,
                    sortDirection: .ascending),
                userId: "123")
            let encodedData = try self.encoder.encode(walletParams)
            let encodedPayload = try! walletParams.encodedPayload()
            XCTAssertEqual(encodedData, encodedPayload)
            XCTAssertEqual(String(data: encodedData, encoding: .utf8)!, """
                {
                    "id":"123",
                    "page":1,
                    "per_page":20,
                    "search_term":"test",
                    "sort_by":"address",
                    "sort_dir":"asc"
                }
            """.uglifiedEncodedString())
        } catch let thrownError {
            XCTFail(thrownError.localizedDescription)
        }
    }

    func testWalletListForAccountParamsEncoding() {
        do {
            let walletParams = WalletListForAccountParams(
                paginatedListParams: StubGenerator.paginatedListParams(
                    searchTerm: "test",
                    sortBy: .address,
                    sortDirection: .ascending),
                accountId: "123",
                owned: true)
            let encodedData = try self.encoder.encode(walletParams)
            let encodedPayload = try! walletParams.encodedPayload()
            XCTAssertEqual(encodedData, encodedPayload)
            XCTAssertEqual(String(data: encodedData, encoding: .utf8)!, """
                {
                    "id":"123",
                    "owned": true,
                    "page":1,
                    "per_page":20,
                    "search_term":"test",
                    "sort_by":"address",
                    "sort_dir":"asc"
                }
            """.uglifiedEncodedString())
        } catch let thrownError {
            XCTFail(thrownError.localizedDescription)
        }
    }

    func testGetAccountParamsEncoding() {
        do {
            let accountParams = AccountGetParams(id: "123")
            let encodedData = try self.encoder.encode(accountParams)
            let encodedPayload = try! accountParams.encodedPayload()
            XCTAssertEqual(encodedData, encodedPayload)
            XCTAssertEqual(String(data: encodedData, encoding: .utf8)!, """
                {
                    "id":"123"
                }
            """.uglifiedEncodedString())
        } catch let thrownError {
            XCTFail(thrownError.localizedDescription)
        }
    }

    func testTransactionRequestCreateParamsEncodingFull() {
        do {
            let transactionRequestParams =
                TransactionRequestCreateParams(type: .receive,
                                               tokenId: "tok_TK1_01cs953xjn9hvz1bcet7swq36j",
                                               amount: 1337,
                                               address: "pgjz791619968896",
                                               accountId: "acc_01cnfz5sh5zmhx4xwd6m1rethy",
                                               userId: "usr_01cq97a3hgm49h8tw28evv5bg2",
                                               providerUserId: "usr_01cq97a3hgm49h8tw28evv5bg2",
                                               correlationId: "31009545-db10-4287-82f4-afb46d9741d8",
                                               requireConfirmation: true,
                                               maxConsumptions: 1,
                                               consumptionLifetime: 1000,
                                               expirationDate: Date(timeIntervalSince1970: 0),
                                               allowAmountOverride: false,
                                               maxConsumptionsPerUser: 5,
                                               exchangeAccountId: "acc_01cnfz5sh5zmhx4xwd6m1rethy",
                                               exchangeWalletAddress: "pgjz791619968896",
                                               metadata: [:],
                                               encryptedMetadata: [:])!
            let encodedData = try self.encoder.encode(transactionRequestParams)
            XCTAssertEqual(String(data: encodedData, encoding: .utf8)!, """
                {
                    "account_id":"acc_01cnfz5sh5zmhx4xwd6m1rethy",
                    "address":"pgjz791619968896",
                    "allow_amount_override":false,
                    "amount":1337,
                    "consumption_lifetime":1000,
                    "correlation_id":"31009545-db10-4287-82f4-afb46d9741d8",
                    "encrypted_metadata":{},
                    "exchange_account_id": "acc_01cnfz5sh5zmhx4xwd6m1rethy",
                    "exchange_wallet_address": "pgjz791619968896",
                    "expiration_date":"1970-01-01T00:00:00Z",
                    "max_consumptions":1,
                    "max_consumptions_per_user":5,
                    "metadata":{},
                    "provider_user_id":"usr_01cq97a3hgm49h8tw28evv5bg2",
                    "require_confirmation":true,
                    "token_id":"tok_TK1_01cs953xjn9hvz1bcet7swq36j",
                    "type":"receive",
                    "user_id":"usr_01cq97a3hgm49h8tw28evv5bg2"
                }
            """.uglifiedEncodedString())
        } catch let thrownError {
            XCTFail(thrownError.localizedDescription)
        }
    }

    func testTransactionConsumptionParamsEncodingFull() {
        do {
            let transactionRequest = TransactionRequest(id: "0a8a4a98-794b-419e-b92d-514e83657e75",
                                                        type: .receive,
                                                        token: StubGenerator.token(id: "tok_TK1_01cs953xjn9hvz1bcet7swq36j"),
                                                        amount: 1337,
                                                        address: "3bfe0ff7-f43e-4ac6-bdf9-c4a290c40d0d",
                                                        user: StubGenerator.user(),
                                                        account: nil,
                                                        correlationId: "31009545-db10-4287-82f4-afb46d9741d8",
                                                        status: .valid,
                                                        socketTopic: "transaction_request:0a8a4a98-794b-419e-b92d-514e83657e75",
                                                        requireConfirmation: true,
                                                        maxConsumptions: 1,
                                                        consumptionLifetime: 1000,
                                                        expirationDate: nil,
                                                        expirationReason: nil,
                                                        createdAt: nil,
                                                        expiredAt: nil,
                                                        allowAmountOverride: true,
                                                        maxConsumptionsPerUser: nil,
                                                        formattedId: "|0a8a4a98-794b-419e-b92d-514e83657e75",
                                                        exchangeAccountId: nil,
                                                        exchangeWalletAddress: nil,
                                                        exchangeAccount: nil,
                                                        exchangeWallet: nil,
                                                        metadata: [:],
                                                        encryptedMetadata: [:])
            let transactionConsumptionParams = TransactionConsumptionParams(transactionRequest: transactionRequest,
                                                                            address: "456",
                                                                            accountId: "acc_01cnfz5sh5zmhx4xwd6m1rethy",
                                                                            userId: "usr_01cq97a3hgm49h8tw28evv5bg2",
                                                                            providerUserId: "usr_01cq97a3hgm49h8tw28evv5bg2",
                                                                            amount: nil,
                                                                            idempotencyToken: "123",
                                                                            correlationId: "321",
                                                                            tokenId: "tok_TK1_01cs953xjn9hvz1bcet7swq36j",
                                                                            exchangeAccountId: "acc_01cnfz5sh5zmhx4xwd6m1rethy",
                                                                            exchangeWalletAddress: "pgjz791619968896",
                                                                            metadata: [:],
                                                                            encryptedMetadata: [:])
            let encodedData = try self.encoder.encode(transactionConsumptionParams)
            let encodedPayload = try! transactionConsumptionParams!.encodedPayload()
            XCTAssertEqual(encodedData, encodedPayload)
            XCTAssertEqual(String(data: encodedData, encoding: .utf8)!, """
                {
                    "account_id":"acc_01cnfz5sh5zmhx4xwd6m1rethy",
                    "address":"456",
                    "amount":null,
                    "correlation_id":"321",
                    "encrypted_metadata":{},
                    "exchange_account_id": "acc_01cnfz5sh5zmhx4xwd6m1rethy",
                    "exchange_wallet_address": "pgjz791619968896",
                    "formatted_transaction_request_id":"|0a8a4a98-794b-419e-b92d-514e83657e75",
                    "idempotency_token":"123",
                    "metadata":{},
                    "provider_user_id":"usr_01cq97a3hgm49h8tw28evv5bg2",
                    "token_id": "tok_TK1_01cs953xjn9hvz1bcet7swq36j",
                    "user_id":"usr_01cq97a3hgm49h8tw28evv5bg2"
                }
            """.uglifiedEncodedString())
        } catch let thrownError {
            XCTFail(thrownError.localizedDescription)
        }
    }
}
