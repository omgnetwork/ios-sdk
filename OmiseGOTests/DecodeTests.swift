//
//  DecodeTests.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 13/11/2017.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

import XCTest
@testable import OmiseGO

class DecodeTests: XCTestCase {

    let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .custom({return try dateDecodingStrategy(decoder: $0)})
        return jsonDecoder
    }()

    func jsonData(withFileName name: String) throws -> Data {
        let bundle = Bundle(for: FixtureClient.self)
        let directoryURL = bundle.url(forResource: "Fixtures/objects", withExtension: nil)!
        let filePath = (name as NSString).appendingPathExtension("json")! as String
        let fixtureFileURL = directoryURL.appendingPathComponent(filePath)
        return try Data(contentsOf: fixtureFileURL)
    }

    func testCustomDateDecodingStrategy() {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .custom({return try dateDecodingStrategy(decoder: $0)})
        do {
            let jsonData = try self.jsonData(withFileName: "dates")
            let decodedData = try self.jsonDecoder.decode(DateDummy.self, from: jsonData)
            XCTAssertEqual(decodedData.date1,
                           "2018-01-01T01:00:00.000000Z".toDate(withFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"))
            XCTAssertEqual(decodedData.date2,
                           "2018-01-01T02:00:00.000Z".toDate(withFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ"))
            XCTAssertEqual(decodedData.date3,
                           "2018-01-01T03:00:00Z".toDate(withFormat: "yyyy-MM-dd'T'HH:mm:ssZ"))
        } catch let thrownError {
            XCTFail(thrownError.localizedDescription)
        }
    }

    func testCustomInvalidDateDecodingStrategy() {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .custom({return try dateDecodingStrategy(decoder: $0)})
        do {
            let jsonData = try self.jsonData(withFileName: "dates_invalid")
            _ = try self.jsonDecoder.decode(DateInvalidDummy.self, from: jsonData)
        } catch let error as OmiseGOError {
            XCTAssertEqual(error.message, "unexpected error: Invalid date format")
        } catch _ {
            XCTFail("Unexpected error")
        }
    }

    func testMetadaDecoding() {
        do {
            let jsonData = try self.jsonData(withFileName: "metadata")
            let decodedData =  try self.jsonDecoder.decode(MetadataDummy.self, from: jsonData)
            guard let metadata = decodedData.metadata else {
                XCTFail("Failed to decode metadata")
                return
            }
            XCTAssertEqual(metadata["a_string"] as? String, "some_string")
            XCTAssertEqual(metadata["an_integer"] as? Int, 1)
            XCTAssertEqual(metadata["a_bool"] as? Bool, true)
            XCTAssertEqual(metadata["a_double"] as? Double, 12.34)
            XCTAssertNil(metadata["a_null_key"])
            guard let object: [String: Any] = metadata["an_object"] as? [String: Any] else {
                XCTFail("could not decode object")
                return
            }
            XCTAssertEqual(object["a_key"] as? String, "a_value")
            guard let nestedObject: [String: Any] = object["a_nested_object"] as? [String: Any] else {
                XCTFail("Could not decode nested object")
                return
            }
            XCTAssertEqual(nestedObject["a_nested_key"] as? String, "a_nested_value")
            guard let array: [Any] = metadata["an_array"] as? [Any] else {
                XCTFail("Could not decode array")
                return
            }
            XCTAssertTrue(array.count == 2)
            XCTAssertEqual(array[0] as? String, "value_1")
            XCTAssertEqual(array[1] as? String, "value_2")
            guard let metadataArray = decodedData.metadataArray else {
                XCTFail("Could not decode array")
                return
            }
            XCTAssertEqual(metadataArray[0] as? String, "value_1")
            XCTAssertEqual(metadataArray[1] as? Int, 1)
            XCTAssertEqual(metadataArray[2] as? Bool, true)
            XCTAssertEqual(metadataArray[3] as? Double, 13.37)
            guard let nestedObjectInArray = metadataArray[4] as? [String: Any] else {
                XCTFail("Could not decode nested object in array")
                return
            }
            XCTAssertEqual(nestedObjectInArray["a_key"] as? String, "a_value")
            guard let nestedArrayInArray = metadataArray[5] as? [Any] else {
                XCTFail("Could not decode nested array in array")
                return
            }
            XCTAssertEqual(nestedArrayInArray[0] as? String, "a_nested_value")
            guard let optionalMetadata = decodedData.optionalMetadata else {
                XCTFail("Could not decode optional metadata")
                return
            }
            XCTAssertEqual(optionalMetadata["a_string"] as? String, "some_string")
            guard let optionalMetadataArray = decodedData.optionalMetadataArray else {
                XCTFail("Could not decode optional metadata")
                return
            }
            XCTAssertEqual(optionalMetadataArray[0] as? String, "a_value")
        } catch let thrownError {
            XCTFail(thrownError.localizedDescription)
        }
    }

    func testMetadaNullDecoding() {
        do {
            let jsonData = try self.jsonData(withFileName: "metadata_null")
            let decodedData =  try self.jsonDecoder.decode(MetadataDummy.self, from: jsonData)
            XCTAssertEqual(decodedData.metadata!.count, 0)
        } catch let thrownError {
            XCTFail(thrownError.localizedDescription)
        }
    }

    func testJSONResponseDecoding() {
        do {
            let jsonData = try self.jsonData(withFileName: "json_response")
            let decodedData =  try self.jsonDecoder.decode(OMGJSONResponse<[String: String]>.self, from: jsonData)
            XCTAssertEqual(decodedData.version, "1")
            XCTAssertEqual(decodedData.success, true)
            switch decodedData.data {
            case .success(data: let content):
                XCTAssertEqual(content["a_key"], "a_value")
            case .fail(error: let error):
                XCTFail(error.localizedDescription)
            }
        } catch let thrownError {
            XCTFail(thrownError.localizedDescription)
        }
    }

    func testJSONListReponseDecoding() {
        do {
            let jsonData = try self.jsonData(withFileName: "json_list_response")
            let decodedData =
                try self.jsonDecoder.decode(OMGJSONResponse<OMGJSONListResponse<String>>.self, from: jsonData)
            XCTAssertEqual(decodedData.version, "1")
            XCTAssertEqual(decodedData.success, true)
            switch decodedData.data {
            case .success(data: let listResponse):
                let list = listResponse.data
                XCTAssertTrue(list.count == 2)
                XCTAssertEqual(list[0], "value_1")
                XCTAssertEqual(list[1], "value_2")
            case .fail(error: let error):
                XCTFail(error.localizedDescription)
            }
        } catch let thrownError {
            XCTFail(thrownError.localizedDescription)
        }
    }

    func testJSONPaginatedListReponseDecoding() {
        do {
            let jsonData = try self.jsonData(withFileName: "json_list_response")
            let decodedData =
                try self.jsonDecoder.decode(OMGJSONResponse<OMGJSONPaginatedListResponse<String>>.self, from: jsonData)
            XCTAssertEqual(decodedData.version, "1")
            XCTAssertEqual(decodedData.success, true)
            switch decodedData.data {
            case .success(data: let listResponse):
                let list = listResponse.data
                XCTAssertTrue(list.count == 2)
                XCTAssertEqual(list[0], "value_1")
                XCTAssertEqual(list[1], "value_2")
                let pagination = listResponse.pagination
                XCTAssertEqual(pagination.currentPage, 1)
                XCTAssertEqual(pagination.perPage, 10)
                XCTAssertEqual(pagination.isFirstPage, true)
                XCTAssertEqual(pagination.isLastPage, true)
            case .fail(error: let error):
                XCTFail(error.localizedDescription)
            }
        } catch let thrownError {
            XCTFail(thrownError.localizedDescription)
        }
    }

    func testUserDecoding() {
        do {
            let jsonData = try self.jsonData(withFileName: "user")
            let decodedData = try self.jsonDecoder.decode(User.self, from: jsonData)
            XCTAssertEqual(decodedData.id, "cec34607-0761-4a59-8357-18963e42a1aa")
            XCTAssertEqual(decodedData.providerUserId, "wijf-fbancomw-dqwjudb")
            XCTAssertEqual(decodedData.username, "john.doe@example.com")
        } catch let thrownError {
            XCTFail(thrownError.localizedDescription)
        }
    }

    func testMintedTokenDecoding() {
        do {
            let jsonData = try self.jsonData(withFileName: "minted_token")
            let decodedData = try self.jsonDecoder.decode(MintedToken.self, from: jsonData)
            XCTAssertEqual(decodedData.id, "OMG:123")
            XCTAssertEqual(decodedData.symbol, "OMG")
            XCTAssertEqual(decodedData.name, "OmiseGO")
            XCTAssertEqual(decodedData.subUnitToUnit, 100000000)
        } catch let thrownError {
            XCTFail(thrownError.localizedDescription)
        }
    }

    func testSettingDecoding() {
        do {
            let jsonData = try self.jsonData(withFileName: "setting")
            let decodedData = try self.jsonDecoder.decode(Setting.self, from: jsonData)
            XCTAssertTrue(decodedData.mintedTokens.count == 1)
            XCTAssertEqual(decodedData.mintedTokens[0].id, "OMG:123")
            XCTAssertEqual(decodedData.mintedTokens[0].symbol, "OMG")
            XCTAssertEqual(decodedData.mintedTokens[0].name, "OmiseGO")
            XCTAssertEqual(decodedData.mintedTokens[0].subUnitToUnit, 100000000)
        } catch let thrownError {
            XCTFail(thrownError.localizedDescription)
        }
    }

    func testBalanceDecoding() {
        do {
            let jsonData = try self.jsonData(withFileName: "balance")
            let decodedData = try self.jsonDecoder.decode(Balance.self, from: jsonData)
            XCTAssertEqual(decodedData.amount, 103100)
            XCTAssertEqual(decodedData.mintedToken.id, "OMG:123")
            XCTAssertEqual(decodedData.mintedToken.symbol, "OMG")
            XCTAssertEqual(decodedData.mintedToken.name, "OmiseGO")
            XCTAssertEqual(decodedData.mintedToken.subUnitToUnit, 10000)
        } catch let thrownError {
            XCTFail(thrownError.localizedDescription)
        }
    }

    func testAddressDecoding() {
        do {
            let jsonData = try self.jsonData(withFileName: "address")
            let decodedData = try self.jsonDecoder.decode(Address.self, from: jsonData)
            XCTAssertEqual(decodedData.address, "2c2e0f2e-fa0f-4abe-8516-9e92cf003486")
            XCTAssertTrue(decodedData.balances.count == 1)
            XCTAssertEqual(decodedData.balances[0].amount, 103100)
            XCTAssertEqual(decodedData.balances[0].mintedToken.id, "OMG:123")
            XCTAssertEqual(decodedData.balances[0].mintedToken.symbol, "OMG")
            XCTAssertEqual(decodedData.balances[0].mintedToken.name, "OmiseGO")
            XCTAssertEqual(decodedData.balances[0].mintedToken.subUnitToUnit, 10000)
        } catch let thrownError {
            XCTFail(thrownError.localizedDescription)
        }
    }

    func testAPIErrorDecoding() {
        do {
            let jsonData = try self.jsonData(withFileName: "api_error")
            let decodedData = try self.jsonDecoder.decode(APIError.self, from: jsonData)
            XCTAssertEqual(decodedData.description, "Invalid parameters")
            switch decodedData.code {
            case .invalidParameters: XCTAssertTrue(true)
            default: XCTFail("Failed to decode the error code")
            }
        } catch let thrownError {
            XCTFail(thrownError.localizedDescription)
        }
    }

    func testTransactionRequestDecoding() {
        do {
            let jsonData = try self.jsonData(withFileName: "transaction_request")
            let decodedData = try self.jsonDecoder.decode(TransactionRequest.self, from: jsonData)
            XCTAssertEqual(decodedData.id, "8eb0160e-1c96-481a-88e1-899399cc84dc")
            XCTAssertEqual(decodedData.mintedToken.id, "BTC:861020af-17b6-49ee-a0cb-661a4d2d1f95")
            XCTAssertEqual(decodedData.amount, 1337)
            XCTAssertEqual(decodedData.address, "3b7f1c68-e3bd-4f8f-9916-4af19be95d00")
            XCTAssertEqual(decodedData.correlationId, "31009545-db10-4287-82f4-afb46d9741d8")
        } catch let thrownError {
            XCTFail(thrownError.localizedDescription)
        }
    }

    func testTransactionConsumeDecoding() {
        do {
            let jsonData = try self.jsonData(withFileName: "transaction_consume")
            let decodedData = try self.jsonDecoder.decode(TransactionConsume.self, from: jsonData)
            XCTAssertEqual(decodedData.id, "8eb0160e-1c96-481a-88e1-899399cc84dc")
            XCTAssertEqual(decodedData.status, .confirmed)
            XCTAssertEqual(decodedData.amount, 1337)
            let mintedToken = decodedData.mintedToken
            XCTAssertEqual(mintedToken.id, "BTC:123")
            XCTAssertEqual(mintedToken.symbol, "BTC")
            XCTAssertEqual(mintedToken.name, "Bitcoin")
            XCTAssertEqual(mintedToken.subUnitToUnit, 100000)
            XCTAssertEqual(decodedData.correlationId, "31009545-db10-4287-82f4-afb46d9741d8")
            XCTAssertEqual(decodedData.idempotencyToken, "31009545-db10-4287-82f4-afb46d9741d8")
            XCTAssertEqual(decodedData.transactionId, "6ca40f34-6eaa-43e1-b2e1-a94ff3660988")
            XCTAssertEqual(decodedData.userId, "6f56efa1-caf9-4348-8e0f-f5af283f17ee")
            XCTAssertEqual(decodedData.transactionRequestId, "907056a4-fc2d-47cb-af19-5e73aade7ece")
            XCTAssertEqual(decodedData.address, "3b7f1c68-e3bd-4f8f-9916-4af19be95d00")
        } catch let thrownError {
            XCTFail(thrownError.localizedDescription)
        }
    }

    func testTransactionDecoding() {
        do {
            let jsonData = try self.jsonData(withFileName: "transaction")
            let decodedData = try self.jsonDecoder.decode(Transaction.self, from: jsonData)
            XCTAssertEqual(decodedData.id, "ce3982f5-4a27-498d-a91b-7bb2e2a8d3d1")
            let from = decodedData.from
            XCTAssertEqual(from.address, "1e3982f5-4a27-498d-a91b-7bb2e2a8d3d1")
            let fromMintedToken = from.mintedToken
            XCTAssertEqual(fromMintedToken.id, "BTC:xe3982f5-4a27-498d-a91b-7bb2e2a8d3d1")
            XCTAssertEqual(fromMintedToken.symbol, "BTC")
            XCTAssertEqual(fromMintedToken.name, "Bitcoin")
            XCTAssertEqual(fromMintedToken.subUnitToUnit, 100)
            let to = decodedData.to
            XCTAssertEqual(to.address, "2e3982f5-4a27-498d-a91b-7bb2e2a8d3d1")
            let toMintedToken = to.mintedToken
            XCTAssertEqual(toMintedToken.id, "BTC:xe3982f5-4a27-498d-a91b-7bb2e2a8d3d1")
            XCTAssertEqual(toMintedToken.symbol, "BTC")
            XCTAssertEqual(toMintedToken.name, "Bitcoin")
            XCTAssertEqual(toMintedToken.subUnitToUnit, 100)
            let exchange = decodedData.exchange
            XCTAssertEqual(exchange.rate, 1)
            XCTAssertEqual(decodedData.status, .confirmed)
            XCTAssertEqual(decodedData.createdAt, "2018-01-01T00:00:00Z".toDate())
            XCTAssertEqual(decodedData.updatedAt, "2018-01-01T10:00:00Z".toDate())
            XCTAssertEqual(decodedData.metadata.count, 0)
        } catch let thrownError {
            XCTFail(thrownError.localizedDescription)
        }
    }

    func testPaginationDecoding() {
        do {
            let jsonData = try self.jsonData(withFileName: "pagination")
            let decodedData = try self.jsonDecoder.decode(Pagination.self, from: jsonData)
            XCTAssertEqual(decodedData.currentPage, 1)
            XCTAssertEqual(decodedData.perPage, 10)
            XCTAssertEqual(decodedData.isFirstPage, true)
            XCTAssertEqual(decodedData.isLastPage, true)
        } catch let thrownError {
            XCTFail(thrownError.localizedDescription)
        }
    }

    func testTransactionSourceDecoding() {
        do {
            let jsonData = try self.jsonData(withFileName: "transaction_source")
            let decodedData = try self.jsonDecoder.decode(TransactionSource.self, from: jsonData)
            XCTAssertEqual(decodedData.address, "2e3982f5-4a27-498d-a91b-7bb2e2a8d3d1")
            XCTAssertEqual(decodedData.amount, 1000)
            let mintedToken: MintedToken = decodedData.mintedToken
            XCTAssertEqual(mintedToken.id, "BTC:xe3982f5-4a27-498d-a91b-7bb2e2a8d3d1")
            XCTAssertEqual(mintedToken.symbol, "BTC")
            XCTAssertEqual(mintedToken.name, "Bitcoin")
            XCTAssertEqual(mintedToken.subUnitToUnit, 100)
        } catch let thrownError {
            XCTFail(thrownError.localizedDescription)
        }
    }

    func testTransactionExchangeDecoding() {
        do {
            let jsonData = try self.jsonData(withFileName: "transaction_exchange")
            let decodedData = try self.jsonDecoder.decode(TransactionExchange.self, from: jsonData)
            XCTAssertEqual(decodedData.rate, 1)
        } catch let thrownError {
            XCTFail(thrownError.localizedDescription)
        }
    }

}
