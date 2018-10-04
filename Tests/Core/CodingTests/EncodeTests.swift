//
//  EncodeTests.swift
//  Tests
//
//  Created by Mederic Petit on 5/2/2018.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

import BigInt
@testable import OmiseGO
import XCTest

extension String {
    func uglifiedEncodedString() -> String {
        return replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
    }
}

class EncodeTests: XCTestCase {
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

    func testMetadaEncoding() {
        let metadata: [String: Any] = [
            "a_string": "some_string",
            "an_integer": 1,
            "a_bool": true,
            "a_double": 12.34,
            "an_object": [
                "a_key": "a_value",
                "a_nested_object": ["a_nested_key": "a_nested_value"],
                "a_nil_value": nil
            ],
            "an_array": ["value_1", "value_2"]
        ]
        let metadataArray: [Any] = ["value_1", 123, true, 13.37, ["a_key": "a_value"], ["a_value", nil]]
        let optionalMetadata: [String: Any] = ["a_key": "a_value"]
        let optionalMetadataArray: [Any] = ["a_value"]
        let metadataDummy = TestMetadata(metadata: metadata,
                                         metadataArray: metadataArray,
                                         optionalMetadata: optionalMetadata,
                                         optionalMetadataArray: optionalMetadataArray,
                                         unavailableMetadata: nil,
                                         unavailableMetadataArray: nil)
        guard let encodedData = try? metadataDummy.encodedPayload() else {
            XCTFail("Could not encode metadata")
            return
        }
        let jsonString = String(data: encodedData, encoding: .utf8)!
        XCTAssertEqual(jsonString, """
        {
            "metadata":{
                "a_bool":true,
                "a_double":12.34,
                "a_string":"some_string",
                "an_array":["value_1","value_2"],
                "an_integer":1,
                "an_object":{
                    "a_key":"a_value",
                    "a_nested_object":{
                        "a_nested_key":"a_nested_value"
                    },
                    "a_nil_value": null
                }
            },
            "metadata_array":[
                "value_1",
                123,
                true,
                13.369999999999999,
                {"a_key":"a_value"},
                ["a_value",null]
            ],
            "optional_metadata":{
                "a_key":"a_value"
            },
            "optional_metadata_array":["a_value"]
        }
        """.uglifiedEncodedString())
    }

    func testMetadaNullEncoding() {
        let metadataDummy = TestMetadata(metadata: nil,
                                         metadataArray: nil,
                                         optionalMetadata: nil,
                                         optionalMetadataArray: nil,
                                         unavailableMetadata: nil,
                                         unavailableMetadataArray: nil)
        guard let encodedData = try? metadataDummy.encodedPayload() else {
            XCTFail("Could not encode metadata")
            return
        }
        let jsonString = String(data: encodedData, encoding: .utf8)!
        XCTAssertEqual(jsonString, """
            {
                "metadata":{},
                "metadata_array":[]
            }
        """.uglifiedEncodedString())
    }

    func testBigIntSuccessfullyEncodeWithInt32Size() {
        let encodable = TestBigUInt(value: "2147483647")
        do {
            let encodedData = try self.encoder.encode(encodable)
            XCTAssertEqual(String(data: encodedData, encoding: .utf8)!, """
                {"value": 2147483647}
            """.uglifiedEncodedString())
        } catch _ {
            XCTFail("Should not raise an error")
        }
    }

    func testBigIntSuccessfullyEncodeWithInt64Size() {
        let encodable = TestBigUInt(value: "922337203685400")
        do {
            let encodedData = try self.encoder.encode(encodable)
            XCTAssertEqual(String(data: encodedData, encoding: .utf8)!, """
                {
                    "value": 922337203685400
                }
            """.uglifiedEncodedString())
        } catch _ {
            XCTFail("Should not raise an error")
        }
    }

    func testBigIntSuccessfullyEncodeWith38Digits() {
        let encodable = TestBigUInt(value: "99999999999999999999999999999999999998")
        do {
            let encodedData = try self.encoder.encode(encodable)
            XCTAssertEqual(String(data: encodedData, encoding: .utf8)!, """
                {
                    "value": 99999999999999999999999999999999999998
                }
            """.uglifiedEncodedString())
        } catch _ {
            XCTFail("Should not raise an error")
        }
    }

    func testBigIntFailsToEncodeWith39Digits() {
        let encodable = TestBigUInt(value: BigInt("999999999999999999999999999999999999991"))
        XCTAssertThrowsError(try serialize(encodable), "Failed to encode value", { error -> Void in
            switch error {
            case let EncodingError.invalidValue(_, context):
                XCTAssertEqual(context.debugDescription, "Value is exceeding the maximum encodable number")
            default:
                XCTFail("Should raise a data corrupted error")
            }
        })
    }

    func testInvalidJSONDictionaryEncoding() {
        let data = "an encoded string".data(using: .utf8)!
        let metadata: [String: Any] = ["invalid_data": data]
        let metadataDummy = TestMetadata(metadata: metadata,
                                         metadataArray: nil,
                                         optionalMetadata: nil,
                                         optionalMetadataArray: nil,
                                         unavailableMetadata: nil,
                                         unavailableMetadataArray: nil)
        XCTAssertThrowsError(try self.encoder.encode(metadataDummy), "Failed to encode dictionary", { error -> Void in
            switch error {
            case let EncodingError.invalidValue(value, context):
                XCTAssertEqual(value as? Data, data)
                XCTAssertEqual(context.debugDescription, "Invalid JSON value")
            default:
                XCTFail("Unexpected error")
            }
        })
    }

    func testInvalidJSONArrayEncoding() {
        let data = "an encoded string".data(using: .utf8)!
        let metadataArray: [Any] = [data]
        let metadataDummy = TestMetadata(metadata: nil,
                                         metadataArray: metadataArray,
                                         optionalMetadata: nil,
                                         optionalMetadataArray: nil,
                                         unavailableMetadata: nil,
                                         unavailableMetadataArray: nil)
        do {
            _ = try self.encoder.encode(metadataDummy)
        } catch let error as EncodingError {
            switch error {
            case let .invalidValue(value, context):
                XCTAssertEqual(value as? Data, data)
                XCTAssertEqual(context.debugDescription, "Invalid JSON value")
            }

        } catch _ {
            XCTFail("Unexpected error")
        }
    }

    func testTransactionRequestCreateParamsEncodingWithoutAmount() {
        do {
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
                                               maxConsumptionsPerUser: 5,
                                               metadata: [:],
                                               encryptedMetadata: [:])!
            let encodedData = try self.encoder.encode(transactionRequestParams)
            let encodedPayload = try! transactionRequestParams.encodedPayload()
            XCTAssertEqual(encodedData, encodedPayload)
            XCTAssertEqual(String(data: encodedData, encoding: .utf8)!, """
                {
                    "address":"3b7f1c68-e3bd-4f8f-9916-4af19be95d00",
                    "allow_amount_override":true,
                    "amount":null,
                    "consumption_lifetime":1000,
                    "correlation_id":"31009545-db10-4287-82f4-afb46d9741d8",
                    "encrypted_metadata":{},
                    "expiration_date":"1970-01-01T00:00:00Z",
                    "max_consumptions":1,
                    "max_consumptions_per_user":5,
                    "metadata":{},
                    "require_confirmation":true,
                    "token_id":"BTC:861020af-17b6-49ee-a0cb-661a4d2d1f95",
                    "type":"receive"
                }
            """.uglifiedEncodedString())
        } catch let thrownError {
            XCTFail(thrownError.localizedDescription)
        }
    }

    func testTransactionRequestCreateParamsEncodingWithAmount() {
        do {
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
                                               maxConsumptionsPerUser: 5,
                                               metadata: [:],
                                               encryptedMetadata: [:])!
            let encodedData = try self.encoder.encode(transactionRequestParams)
            XCTAssertEqual(String(data: encodedData, encoding: .utf8)!, """
                {
                    "address":"3b7f1c68-e3bd-4f8f-9916-4af19be95d00",
                    "allow_amount_override":false,
                    "amount":1337,
                    "consumption_lifetime":1000,
                    "correlation_id":"31009545-db10-4287-82f4-afb46d9741d8",
                    "encrypted_metadata":{},
                    "expiration_date":"1970-01-01T00:00:00Z",
                    "max_consumptions":1,
                    "max_consumptions_per_user":5,
                    "metadata":{},
                    "require_confirmation":true,
                    "token_id":"BTC:861020af-17b6-49ee-a0cb-661a4d2d1f95",
                    "type":"receive"
                }
            """.uglifiedEncodedString())
        } catch let thrownError {
            XCTFail(thrownError.localizedDescription)
        }
    }

    func testTransactionRequestGetParamsEncoding() {
        do {
            let transactionRequestParams =
                TransactionRequestGetParams(formattedId: "|0a8a4a98-794b-419e-b92d-514e83657e75")
            let encodedData = try self.encoder.encode(transactionRequestParams)
            let encodedPayload = try! transactionRequestParams.encodedPayload()
            XCTAssertEqual(encodedData, encodedPayload)
            XCTAssertEqual(String(data: encodedData,
                                  encoding: .utf8)!, """
                                    {
                                        "formatted_id":"|0a8a4a98-794b-419e-b92d-514e83657e75"
                                    }
            """.uglifiedEncodedString())
        } catch let thrownError {
            XCTFail(thrownError.localizedDescription)
        }
    }

    func testTransactionConsumptionParamsWithoutAmountEncoding() {
        do {
            let transactionRequest = TransactionRequest(id: "0a8a4a98-794b-419e-b92d-514e83657e75",
                                                        type: .receive,
                                                        token: StubGenerator.token(id: "BTC:5ee328ec-b9e2-46a5-88bb-c8b15ea6b3c1"),
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
                                                                            amount: nil,
                                                                            idempotencyToken: "123",
                                                                            correlationId: "321",
                                                                            metadata: [:],
                                                                            encryptedMetadata: [:])
            let encodedData = try self.encoder.encode(transactionConsumptionParams)
            let encodedPayload = try! transactionConsumptionParams!.encodedPayload()
            XCTAssertEqual(encodedData, encodedPayload)
            XCTAssertEqual(String(data: encodedData, encoding: .utf8)!, """
                {
                    "address":"456",
                    "amount":null,
                    "correlation_id":"321",
                    "encrypted_metadata":{},
                    "formatted_transaction_request_id":"|0a8a4a98-794b-419e-b92d-514e83657e75",
                    "idempotency_token":"123",
                    "metadata":{}
                }
            """.uglifiedEncodedString())
        } catch let thrownError {
            XCTFail(thrownError.localizedDescription)
        }
    }

    func testPaginationParamsEncoding() {
        do {
            let paginationParams = PaginatedListParams<TestPaginatedListable>(
                page: 1,
                perPage: 20,
                searchTerm: "test",
                sortBy: .aSortableAttribute,
                sortDirection: .ascending)
            let encodedData = try self.encoder.encode(paginationParams)
            let encodedPayload = try! paginationParams.encodedPayload()
            XCTAssertEqual(encodedData, encodedPayload)
            XCTAssertEqual(String(data: encodedData, encoding: .utf8)!, """
                {
                    "page":1,
                    "per_page":20,
                    "search_term":"test",
                    "sort_by":"a_sortable_attribute",
                    "sort_dir":"asc"
                }
            """.uglifiedEncodedString())
        } catch let thrownError {
            XCTFail(thrownError.localizedDescription)
        }
    }

    func testPaginationParamsEncodingWithSearchTerms() {
        do {
            let paginationParams = PaginatedListParams<TestPaginatedListable>(
                page: 1,
                perPage: 20,
                searchTerms: [.aSearchableAttribute: "test"],
                sortBy: .aSortableAttribute,
                sortDirection: .ascending)
            let encodedData = try self.encoder.encode(paginationParams)
            XCTAssertEqual(String(data: encodedData, encoding: .utf8)!, """
                {
                    "page":1,
                    "per_page":20,
                    "search_terms":{"a_searchable_attribute":"test"},
                    "sort_by":"a_sortable_attribute",
                    "sort_dir":"asc"
                }
            """.uglifiedEncodedString())
        } catch let thrownError {
            XCTFail(thrownError.localizedDescription)
        }
    }

    func testPaginationParamsEncodingWithoutSearch() {
        do {
            let paginationParams = PaginatedListParams<TestPaginatedListable>(
                page: 1,
                perPage: 20,
                sortBy: .aSortableAttribute,
                sortDirection: .ascending)
            let encodedData = try self.encoder.encode(paginationParams)
            XCTAssertEqual(String(data: encodedData, encoding: .utf8)!, """
                {
                    "page":1,
                    "per_page":20,
                    "sort_by":"a_sortable_attribute",
                    "sort_dir":"asc"
                }
            """.uglifiedEncodedString())
        } catch let thrownError {
            XCTFail(thrownError.localizedDescription)
        }
    }

    func testTransactionListParamsEncoding() {
        do {
            let transactionParams = TransactionListParams(
                paginatedListParams: StubGenerator.paginatedListParams(
                    searchTerm: "test",
                    sortBy: .createdAt,
                    sortDirection: .descending),
                address: "123")
            let encodedData = try self.encoder.encode(transactionParams)
            let encodedPayload = try! transactionParams.encodedPayload()
            XCTAssertEqual(encodedData, encodedPayload)
            XCTAssertEqual(String(data: encodedData, encoding: .utf8)!, """
                {
                    "address":"123",
                    "page":1,
                    "per_page":20,
                    "search_term":"test",
                    "sort_by":"created_at",
                    "sort_dir":"desc"
                }
            """.uglifiedEncodedString())
        } catch let thrownError {
            XCTFail(thrownError.localizedDescription)
        }
    }

    func testSocketPayloadSendEncoding() {
        do {
            let socketPayload = SocketPayloadSend(topic: "a_topic", event: .join, ref: "1", data: ["a_key": "a_value"])
            let encodedData = try self.encoder.encode(socketPayload)
            let encodedPayload = try! socketPayload.encodedPayload()
            XCTAssertEqual(encodedData, encodedPayload)
            XCTAssertEqual(String(data: encodedData, encoding: .utf8)!, """
                {
                    "data":{"a_key":"a_value"},
                    "event":"phx_join",
                    "ref":"1",
                    "topic":"a_topic"
                }
            """.uglifiedEncodedString())
        } catch let thrownError {
            XCTFail(thrownError.localizedDescription)
        }
    }

    func testTransactionConsumptionConfirmationParamsEncoding() {
        do {
            let transactionConsumptionConfirmationParams = TransactionConsumptionConfirmationParams(id: "0a8a4a98-794b-419e-b92d-514e83657e75")
            let encodedData = try self.encoder.encode(transactionConsumptionConfirmationParams)
            let encodedPayload = try! transactionConsumptionConfirmationParams.encodedPayload()
            XCTAssertEqual(encodedData, encodedPayload)
            XCTAssertEqual(String(data: encodedData,
                                  encoding: .utf8)!, """
                                    {
                                        "id":"0a8a4a98-794b-419e-b92d-514e83657e75"
                                    }
            """.uglifiedEncodedString())
        } catch let thrownError {
            XCTFail(thrownError.localizedDescription)
        }
    }

    func testTransactionParamsEncodingToAddress() {
        do {
            let transactionParams = TransactionCreateParams(fromAddress: "86e274e2-c8dc-46cf-ac4e-d8b26b5aada3",
                                                            toAddress: "2bd75f2f-6e83-4727-a8b5-2849a9715064",
                                                            amount: 1337,
                                                            tokenId: "BTC:06b8ebc3-237b-4631-a1c7-2ecbd1d623c6",
                                                            idempotencyToken: "123",
                                                            metadata: ["a_key": "a_value"],
                                                            encryptedMetadata: ["a_key": "a_value"])

            let encodedData = try self.encoder.encode(transactionParams)
            let encodedPayload = try! transactionParams.encodedPayload()
            XCTAssertEqual(encodedData, encodedPayload)
            XCTAssertEqual(String(data: encodedData, encoding: .utf8)!, """
                {
                    "amount":1337,
                    "encrypted_metadata":{"a_key":"a_value"},
                    "from_address":"86e274e2-c8dc-46cf-ac4e-d8b26b5aada3",
                    "idempotency_token":"123",
                    "metadata":{"a_key":"a_value"},
                    "to_address":"2bd75f2f-6e83-4727-a8b5-2849a9715064",
                    "token_id":"BTC:06b8ebc3-237b-4631-a1c7-2ecbd1d623c6"
                }
            """.uglifiedEncodedString())
        } catch let thrownError {
            XCTFail(thrownError.localizedDescription)
        }
    }

    func testTransactionParamsEncodingToAccountId() {
        do {
            let transactionParams = TransactionCreateParams(fromAddress: "86e274e2-c8dc-46cf-ac4e-d8b26b5aada3",
                                                            toAccountId: "2bd75f2f-6e83-4727-a8b5-2849a9715064",
                                                            amount: 1337,
                                                            tokenId: "BTC:06b8ebc3-237b-4631-a1c7-2ecbd1d623c6",
                                                            idempotencyToken: "123",
                                                            metadata: ["a_key": "a_value"],
                                                            encryptedMetadata: ["a_key": "a_value"])

            let encodedData = try self.encoder.encode(transactionParams)
            let encodedPayload = try! transactionParams.encodedPayload()
            XCTAssertEqual(encodedData, encodedPayload)
            XCTAssertEqual(String(data: encodedData, encoding: .utf8)!, """
                {
                    "amount":1337,
                    "encrypted_metadata":{"a_key":"a_value"},
                    "from_address":"86e274e2-c8dc-46cf-ac4e-d8b26b5aada3",
                    "idempotency_token":"123",
                    "metadata":{"a_key":"a_value"},
                    "to_account_id":"2bd75f2f-6e83-4727-a8b5-2849a9715064",
                    "token_id":"BTC:06b8ebc3-237b-4631-a1c7-2ecbd1d623c6"
                }
            """.uglifiedEncodedString())
        } catch let thrownError {
            XCTFail(thrownError.localizedDescription)
        }
    }

    func testTransactionParamsEncodingToUserId() {
        do {
            let transactionParams = TransactionCreateParams(fromAddress: "86e274e2-c8dc-46cf-ac4e-d8b26b5aada3",
                                                            toProviderUserId: "2bd75f2f-6e83-4727-a8b5-2849a9715064",
                                                            amount: 1337,
                                                            tokenId: "BTC:06b8ebc3-237b-4631-a1c7-2ecbd1d623c6",
                                                            idempotencyToken: "123",
                                                            metadata: ["a_key": "a_value"],
                                                            encryptedMetadata: ["a_key": "a_value"])

            let encodedData = try self.encoder.encode(transactionParams)
            let encodedPayload = try! transactionParams.encodedPayload()
            XCTAssertEqual(encodedData, encodedPayload)
            XCTAssertEqual(String(data: encodedData, encoding: .utf8)!, """
                {
                    "amount":1337,
                    "encrypted_metadata":{"a_key":"a_value"},
                    "from_address":"86e274e2-c8dc-46cf-ac4e-d8b26b5aada3",
                    "idempotency_token":"123",
                    "metadata":{"a_key":"a_value"},
                    "to_provider_user_id":"2bd75f2f-6e83-4727-a8b5-2849a9715064",
                    "token_id":"BTC:06b8ebc3-237b-4631-a1c7-2ecbd1d623c6"
                }
            """.uglifiedEncodedString())
        } catch let thrownError {
            XCTFail(thrownError.localizedDescription)
        }
    }

    func testTransactionParamsEncodingFull() {
        do {
            let transactionParams = TransactionCreateParams(fromAddress: "dqhg022708121978",
                                                            toAddress: "qrxe701832114087",
                                                            amount: 1,
                                                            fromAmount: 1,
                                                            toAmount: 2,
                                                            fromTokenId: "tok_NT2_01cqx98daqa6qf0pdzn3e5csjq",
                                                            toTokenId: "tok_NTN_01cqx8vhhj1h9mb1mw8hj5vs48",
                                                            tokenId: "tok_NTN_01cqx8vhhj1h9mb1mw8hj5vs48",
                                                            fromAccountId: "acc_01cqwwqz8zpsgta8rsm244w8rr",
                                                            toAccountId: "acc_01cqx8qt9hgnbz1vkwhm5ymkbn",
                                                            fromProviderUserId: "123",
                                                            toProviderUserId: "321",
                                                            fromUserId: "usr_01cqx93p4jh939xbq5k71evswe",
                                                            toUserId: "usr_01qqx93p4jh939xbq5k71evswe",
                                                            idempotencyToken: "1234",
                                                            exchangeAccountId: "acc_01cqwwqz8zpsgta8rsm244w8rr",
                                                            exchangeAddress: "dqhg022708121978",
                                                            metadata: ["a_key": "a_value"],
                                                            encryptedMetadata: ["a_key": "a_value"])
            let encodedData = try self.encoder.encode(transactionParams)
            let encodedPayload = try! transactionParams.encodedPayload()
            XCTAssertEqual(encodedData, encodedPayload)
            XCTAssertEqual(String(data: encodedData, encoding: .utf8)!, """
                {
                    "amount":1,
                    "encrypted_metadata":{"a_key":"a_value"},
                    "exchange_account_id": "acc_01cqwwqz8zpsgta8rsm244w8rr",
                    "exchange_address": "dqhg022708121978",
                    "from_account_id":"acc_01cqwwqz8zpsgta8rsm244w8rr",
                    "from_address":"dqhg022708121978",
                    "from_amount":1,
                    "from_provider_user_id":"123",
                    "from_token_id":"tok_NT2_01cqx98daqa6qf0pdzn3e5csjq",
                    "from_user_id":"usr_01cqx93p4jh939xbq5k71evswe",
                    "idempotency_token":"1234",
                    "metadata":{"a_key":"a_value"},
                    "to_account_id":"acc_01cqx8qt9hgnbz1vkwhm5ymkbn",
                    "to_address":"qrxe701832114087",
                    "to_amount":2,
                    "to_provider_user_id":"321",
                    "to_token_id":"tok_NTN_01cqx8vhhj1h9mb1mw8hj5vs48",
                    "to_user_id":"usr_01qqx93p4jh939xbq5k71evswe",
                    "token_id":"tok_NTN_01cqx8vhhj1h9mb1mw8hj5vs48"
                }
            """.uglifiedEncodedString())
        } catch let thrownError {
            XCTFail(thrownError.localizedDescription)
        }
    }

    func testLoginParamsEncoding() {
        do {
            let loginParams = LoginParams(email: "email@example.com", password: "password")
            let encodedData = try self.encoder.encode(loginParams)
            XCTAssertEqual(String(data: encodedData, encoding: .utf8)!, """
                {
                    "email":"email@example.com",
                    "password":"password"
                }
            """.uglifiedEncodedString())
        } catch let thrownError {
            XCTFail(thrownError.localizedDescription)
        }
    }

    func testSignupParamsEncoding() {
        do {
            let signupParams = SignupParams(email: "email@example.com",
                                            password: "password",
                                            passwordConfirmation: "password",
                                            verificationURL: "xxx",
                                            successURL: "yyy")
            let encodedData = try self.encoder.encode(signupParams)
            XCTAssertEqual(String(data: encodedData, encoding: .utf8)!, """
                {
                    "email":"email@example.com",
                    "password":"password",
                    "password_confirmation":"password",
                    "success_url":"yyy",
                    "verification_url":"xxx"
                }
            """.uglifiedEncodedString())
        } catch let thrownError {
            XCTFail(thrownError.localizedDescription)
        }
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
}
