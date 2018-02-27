//
//  EncodeTests.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 5/2/2018 BE.
//  Copyright © 2018 OmiseGO. All rights reserved.
//

import XCTest
@testable import OmiseGO

extension String {

    func uglifiedEncodedString() -> String {
        return replacingOccurrences(of: "\n", with: "").replacingOccurrences(of: " ", with: "")
    }

}

//swiftlint:disable:next type_body_length
class EncodeTests: XCTestCase {

    func testMetadaEncoding() {
        let metadata: [String: Any] = ["a_string": "some_string",
                                       "an_integer": 1,
                                       "a_bool": true,
                                       "a_double": 12.34,
                                       "an_object": ["a_key": "a_value",
                                                     "a_nested_object": ["a_nested_key": "a_nested_value"]],
                                       "an_array": ["value_1", "value_2"]]
        let metadataDummy = MetadataDummy(metadata: metadata)
        guard let encodedData = metadataDummy.encodedPayload() else {
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
                        "a_key":"a_value"},
                    "a_string":"some_string"
                }
            }
            """.uglifiedEncodedString())
    }

    func testMetadaNullEncoding() {
        let metadataDummy = MetadataDummy(metadata: nil)
        guard let encodedData = metadataDummy.encodedPayload() else {
            XCTFail("Could not encode metadata")
            return
        }
        let jsonString = String(data: encodedData, encoding: .utf8)!
        XCTAssertEqual(jsonString, """
            {"metadata":{}}
        """.uglifiedEncodedString())
    }

    func testTransactionRequestCreateParamsEncodingWithoutAmount() {
        do {
            let transactionRequestParams =
                TransactionRequestCreateParams(type: .receive,
                                               mintedTokenId: "BTC:861020af-17b6-49ee-a0cb-661a4d2d1f95",
                                               amount: nil,
                                               address: "3b7f1c68-e3bd-4f8f-9916-4af19be95d00",
                                               correlationId: "31009545-db10-4287-82f4-afb46d9741d8")
            let encodedData = try JSONEncoder().encode(transactionRequestParams)
            XCTAssertEqual(String(data: encodedData, encoding: .utf8)!, """
                {
                    "amount":null,
                    "correlation_id":"31009545-db10-4287-82f4-afb46d9741d8",
                    "token_id":"BTC:861020af-17b6-49ee-a0cb-661a4d2d1f95",
                    "type":"receive",
                    "address":"3b7f1c68-e3bd-4f8f-9916-4af19be95d00"
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
                                               correlationId: "31009545-db10-4287-82f4-afb46d9741d8")
            let encodedData = try JSONEncoder().encode(transactionRequestParams)
            XCTAssertEqual(String(data: encodedData, encoding: .utf8)!, """
                {
                    "amount":1337,
                    "correlation_id":"31009545-db10-4287-82f4-afb46d9741d8",
                    "token_id":"BTC:861020af-17b6-49ee-a0cb-661a4d2d1f95",
                    "type":"receive",
                    "address":"3b7f1c68-e3bd-4f8f-9916-4af19be95d00"
                }
            """.uglifiedEncodedString())
        } catch let thrownError {
            XCTFail(thrownError.localizedDescription)
        }
    }

    func testTransactionRequestGetParamsEncodingWithAmount() {
        do {
            let transactionRequestParams =
                TransactionRequestGetParams(id: "0a8a4a98-794b-419e-b92d-514e83657e75")
            let encodedData = try JSONEncoder().encode(transactionRequestParams)
            XCTAssertEqual(String(data: encodedData,
             encoding: .utf8)!, """
                {"id":"0a8a4a98-794b-419e-b92d-514e83657e75"}
            """.uglifiedEncodedString())
        } catch let thrownError {
            XCTFail(thrownError.localizedDescription)
        }
    }

    func testTransactionConsumeParamsEncoding() {
        do {
            let transactionRequest = TransactionRequest(
                id: "0a8a4a98-794b-419e-b92d-514e83657e75",
                type: .receive,
                mintedToken: StubGenerator.mintedToken(id: "BTC:5ee328ec-b9e2-46a5-88bb-c8b15ea6b3c1"),
                amount: 1337,
                address: "3bfe0ff7-f43e-4ac6-bdf9-c4a290c40d0d",
                correlationId: "31009545-db10-4287-82f4-afb46d9741d8",
                status: .valid)
            let transactionConsumeParams = TransactionConsumeParams(transactionRequest: transactionRequest,
                                                                    address: "456",
                                                                    mintedTokenId: "BTC:123",
                                                                    idempotencyToken: "123",
                                                                    correlationId: "321",
                                                                    metadata: [:])
            let encodedData = try JSONEncoder().encode(transactionConsumeParams)
            XCTAssertEqual(String(data: encodedData, encoding: .utf8)!, """
                {
                    "amount":1337,
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
            let encodedData = try JSONEncoder().encode(paginationParams)
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
            let encodedData = try JSONEncoder().encode(paginationParams)
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
            let encodedData = try JSONEncoder().encode(paginationParams)
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
            let encodedData = try JSONEncoder().encode(transactionParams)
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

}
