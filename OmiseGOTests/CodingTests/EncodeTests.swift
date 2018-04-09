//
//  EncodeTests.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 5/2/2018.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

import XCTest
@testable import OmiseGO

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
        jsonEncoder.dateEncodingStrategy = .custom({return try dateEncodingStrategy(date: $0, encoder: $1)})
        self.encoder = jsonEncoder
    }

    func testMetadaEncoding() {
        let metadata: [String: Any] = ["a_string": "some_string",
                                       "an_integer": 1,
                                       "a_bool": true,
                                       "a_double": 12.34,
                                       "an_object": ["a_key": "a_value",
                                                     "a_nested_object": ["a_nested_key": "a_nested_value"],
                                                     "a_nil_value": nil],
                                       "an_array": ["value_1", "value_2"]]
        let metadataArray: [Any] = ["value_1", 123, true, 13.37, ["a_key": "a_value"], ["a_value", nil]]
        let optionalMetadata: [String: Any] = ["a_key": "a_value"]
        let optionalMetadataArray: [Any] = ["a_value"]
        let metadataDummy = MetadataDummy(metadata: metadata,
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
                    "an_integer":1,
                    "an_array":["value_1","value_2"],
                    "a_double":12.34,
                    "an_object":{
                        "a_nested_object":{
                            "a_nested_key":"a_nested_value"
                        },
                        "a_key":"a_value",
                        "a_nil_value": null},
                    "a_string":"some_string"
                },
                "optional_metadata_array":["a_value"],
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
                }
            }
            """.uglifiedEncodedString())
    }

    func testMetadaNullEncoding() {
        let metadataDummy = MetadataDummy(metadata: nil,
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
                "metadata_array":[],
                "metadata":{}
            }
        """.uglifiedEncodedString())
    }

    func testInvalidJSONDictionaryEncoding() {
        let data = "an encoded string".data(using: .utf8)!
        let metadata: [String: Any] = ["invalid_data": data]
        let metadataDummy = MetadataDummy(metadata: metadata,
                                          metadataArray: nil,
                                          optionalMetadata: nil,
                                          optionalMetadataArray: nil,
                                          unavailableMetadata: nil,
                                          unavailableMetadataArray: nil)
        do {
            _ = try self.encoder.encode(metadataDummy)
        } catch let error as EncodingError {
            switch error {
            case .invalidValue(let value, let context):
                XCTAssertEqual(value as? Data, data)
                XCTAssertEqual(context.debugDescription, "Invalid JSON value")
            }

        } catch _ {
            XCTFail("Unexpected error")
        }
    }

    func testInvalidJSONArrayEncoding() {
        let data = "an encoded string".data(using: .utf8)!
        let metadataArray: [Any] = [data]
        let metadataDummy = MetadataDummy(metadata: nil,
                                          metadataArray: metadataArray,
                                          optionalMetadata: nil,
                                          optionalMetadataArray: nil,
                                          unavailableMetadata: nil,
                                          unavailableMetadataArray: nil)
        do {
            _ = try self.encoder.encode(metadataDummy)
        } catch let error as EncodingError {
            switch error {
            case .invalidValue(let value, let context):
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
                                               mintedTokenId: "BTC:861020af-17b6-49ee-a0cb-661a4d2d1f95",
                                               amount: nil,
                                               address: "3b7f1c68-e3bd-4f8f-9916-4af19be95d00",
                                               correlationId: "31009545-db10-4287-82f4-afb46d9741d8",
                                               requireConfirmation: true,
                                               maxConsumptions: 1,
                                               consumptionLifetime: 1000,
                                               expirationDate: Date(timeIntervalSince1970: 0),
                                               allowAmountOverride: true,
                                               metadata: [:])!
            let encodedData = try self.encoder.encode(transactionRequestParams)
            let encodedPayload = try! transactionRequestParams.encodedPayload()
            XCTAssertEqual(encodedData, encodedPayload)
            XCTAssertEqual(String(data: encodedData, encoding: .utf8)!, """
                {
                    "amount":null,
                    "correlation_id":"31009545-db10-4287-82f4-afb46d9741d8",
                    "max_consumptions":1,
                    "require_confirmation":true,
                    "address":"3b7f1c68-e3bd-4f8f-9916-4af19be95d00",
                    "allow_amount_override":true,
                    "consumption_lifetime":1000,
                    "expiration_date":"1970-01-01T00:00:00Z",
                    "type":"receive",
                    "token_id":"BTC:861020af-17b6-49ee-a0cb-661a4d2d1f95",
                    "metadata":{}
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
                                               mintedTokenId: "BTC:861020af-17b6-49ee-a0cb-661a4d2d1f95",
                                               amount: 1337,
                                               address: "3b7f1c68-e3bd-4f8f-9916-4af19be95d00",
                                               correlationId: "31009545-db10-4287-82f4-afb46d9741d8",
                                               requireConfirmation: true,
                                               maxConsumptions: 1,
                                               consumptionLifetime: 1000,
                                               expirationDate: Date(timeIntervalSince1970: 0),
                                               allowAmountOverride: false,
                                               metadata: [:])!
            let encodedData = try self.encoder.encode(transactionRequestParams)
            XCTAssertEqual(String(data: encodedData, encoding: .utf8)!, """
                {
                    "amount":1337,
                    "correlation_id":"31009545-db10-4287-82f4-afb46d9741d8",
                    "max_consumptions":1,
                    "require_confirmation":true,
                    "address":"3b7f1c68-e3bd-4f8f-9916-4af19be95d00",
                    "allow_amount_override":false,
                    "consumption_lifetime":1000,
                    "expiration_date":"1970-01-01T00:00:00Z",
                    "type":"receive",
                    "token_id":"BTC:861020af-17b6-49ee-a0cb-661a4d2d1f95",
                    "metadata":{}
                }
            """.uglifiedEncodedString())
        } catch let thrownError {
            XCTFail(thrownError.localizedDescription)
        }
    }

    func testTransactionRequestGetParamsEncoding() {
        do {
            let transactionRequestParams =
                TransactionRequestGetParams(id: "0a8a4a98-794b-419e-b92d-514e83657e75")
            let encodedData = try self.encoder.encode(transactionRequestParams)
            let encodedPayload = try! transactionRequestParams.encodedPayload()
            XCTAssertEqual(encodedData, encodedPayload)
            XCTAssertEqual(String(data: encodedData,
                                  encoding: .utf8)!, """
                {"id":"0a8a4a98-794b-419e-b92d-514e83657e75"}
            """.uglifiedEncodedString())
        } catch let thrownError {
            XCTFail(thrownError.localizedDescription)
        }
    }

    func testTransactionConsumptionParamsWithoutAmountEncoding() {
        do {
            let transactionRequest = TransactionRequest(id: "0a8a4a98-794b-419e-b92d-514e83657e75",
                                                        type: .receive,
                                                        mintedToken: StubGenerator.mintedToken(id: "BTC:5ee328ec-b9e2-46a5-88bb-c8b15ea6b3c1"),
                                                        amount: 1337,
                                                        address: "3bfe0ff7-f43e-4ac6-bdf9-c4a290c40d0d",
                                                        correlationId: "31009545-db10-4287-82f4-afb46d9741d8",
                                                        status: .valid,
                                                        socketTopic: "transaction_request:0a8a4a98-794b-419e-b92d-514e83657e75",
                                                        requireConfirmation: true,
                                                        maxConsumptions: 1,
                                                        consumptionLifetime: 1000,
                                                        expirationDate: nil,
                                                        expirationReason: nil,
                                                        expiredAt: nil,
                                                        allowAmountOverride: true,
                                                        metadata: [:])
            let transactionConsumptionParams = TransactionConsumptionParams(transactionRequest: transactionRequest,
                                                                            address: "456",
                                                                            mintedTokenId: "BTC:123",
                                                                            amount: nil,
                                                                            idempotencyToken: "123",
                                                                            correlationId: "321",
                                                                            expirationDate: Date(timeIntervalSince1970: 0),
                                                                            metadata: [:])
            let encodedData = try self.encoder.encode(transactionConsumptionParams)
            let encodedPayload = try! transactionConsumptionParams!.encodedPayload()
            XCTAssertEqual(encodedData, encodedPayload)
            XCTAssertEqual(String(data: encodedData, encoding: .utf8)!, """
                {
                    "amount":null,
                    "transaction_request_id":"0a8a4a98-794b-419e-b92d-514e83657e75",
                    "metadata":{},
                    "token_id":"BTC:123",
                    "correlation_id":"321",
                    "address":"456"
                }
            """.uglifiedEncodedString())
        } catch let thrownError {
            XCTFail(thrownError.localizedDescription)
        }
    }

    func testPaginationParamsEncoding() {
        do {
            let paginationParams = PaginationParams<SortableDummy>(
                page: 1,
                perPage: 20,
                searchTerm: "test",
                searchTerms: nil,
                sortBy: .aSortableAttribute,
                sortDirection: .ascending)
            let encodedData = try self.encoder.encode(paginationParams)
            let encodedPayload = try! paginationParams.encodedPayload()
            XCTAssertEqual(encodedData, encodedPayload)
            XCTAssertEqual(String(data: encodedData, encoding: .utf8)!, """
                {
                    "search_term":"test",
                    "per_page":20,
                    "sort_dir":"asc",
                    "sort_by":"a_sortable_attribute",
                    "page":1
                }
            """.uglifiedEncodedString())
        } catch let thrownError {
            XCTFail(thrownError.localizedDescription)
        }
    }

    func testPaginationParamsEncodingWithBothSearchTermAndSearchTerms() {
        do {
            let paginationParams = PaginationParams<SortableDummy>(
                page: 1,
                perPage: 20,
                searchTerm: "test",
                searchTerms: [.aSearchableAttribute: "test"],
                sortBy: .aSortableAttribute,
                sortDirection: .ascending)
            let encodedData = try self.encoder.encode(paginationParams)
            XCTAssertEqual(String(data: encodedData, encoding: .utf8)!, """
                {
                    "per_page":20,
                    "search_terms":{"a_searchable_attribute":"test"},
                    "sort_dir":"asc",
                    "sort_by":"a_sortable_attribute",
                    "page":1
                }
            """.uglifiedEncodedString())
        } catch let thrownError {
            XCTFail(thrownError.localizedDescription)
        }
    }

    func testPaginationParamsEncodingWithNilValues() {
        do {
            let paginationParams = PaginationParams<SortableDummy>(
                page: 1,
                perPage: 20,
                searchTerm: nil,
                searchTerms: nil,
                sortBy: .aSortableAttribute,
                sortDirection: .ascending)
            let encodedData = try self.encoder.encode(paginationParams)
            XCTAssertEqual(String(data: encodedData, encoding: .utf8)!, """
                {
                    "per_page":20,
                    "sort_dir":"asc",
                    "sort_by":"a_sortable_attribute",
                    "page":1
                }
            """.uglifiedEncodedString())
        } catch let thrownError {
            XCTFail(thrownError.localizedDescription)
        }
    }

    func testTransactionListParamsEncoding() {
        do {
            let transactionParams = TransactionListParams(
                paginationParams: StubGenerator.paginationParams(
                    searchTerm: "test",
                    sortBy: .createdAt,
                    sortDirection: .descending),
                address: "123")
            let encodedData = try self.encoder.encode(transactionParams)
            let encodedPayload = try! transactionParams.encodedPayload()
            XCTAssertEqual(encodedData, encodedPayload)
            XCTAssertEqual(String(data: encodedData, encoding: .utf8)!, """
                {
                    "page":1,
                    "search_term":"test",
                    "per_page":20,
                    "sort_dir":"desc",
                    "sort_by":"created_at",
                    "address":"123"
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
                    "topic":"a_topic",
                    "event":"phx_join",
                    "ref":"1"
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
                {"id":"0a8a4a98-794b-419e-b92d-514e83657e75"}
            """.uglifiedEncodedString())
        } catch let thrownError {
            XCTFail(thrownError.localizedDescription)
        }
    }

}
