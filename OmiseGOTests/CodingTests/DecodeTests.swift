//
//  DecodeTests.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 13/11/2017.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

@testable import OmiseGO
import XCTest

class DecodeTests: XCTestCase {
    let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .custom({ try dateDecodingStrategy(decoder: $0) })
        return jsonDecoder
    }()

    func jsonData(withFileName name: String) throws -> Data {
        let bundle = Bundle(for: FixtureClient.self)
        let directoryURL = bundle.url(forResource: "Fixtures/objects", withExtension: nil)!
        let filePath = (name as NSString).appendingPathExtension("json")! as String
        let fixtureFileURL = directoryURL.appendingPathComponent(filePath)
        return try Data(contentsOf: fixtureFileURL)
    }

    func testSuccessfullyDecodesANumberWithInt32Size() {
        do {
            let jsonData = try self.jsonData(withFileName: "bigint_int32")
            let decodedData = try self.jsonDecoder.decode(BigIntDummy.self, from: jsonData)
            XCTAssertEqual(decodedData.value.description, "2147483647")
        } catch let thrownError {
            XCTFail(thrownError.localizedDescription)
        }
    }

    func testSuccessfullyDecodesANumberWithInt64Size() {
        do {
            let jsonData = try self.jsonData(withFileName: "bigint_int64")
            let decodedData = try self.jsonDecoder.decode(BigIntDummy.self, from: jsonData)
            XCTAssertEqual(decodedData.value.description, "922337203685400")
        } catch let thrownError {
            XCTFail(thrownError.localizedDescription)
        }
    }

    func testSuccessfullyDecodesANumberWith38Digits() {
        do {
            let jsonData = try self.jsonData(withFileName: "bigint_over_int64")
            let decodedData = try self.jsonDecoder.decode(BigIntDummy.self, from: jsonData)
            XCTAssertEqual(decodedData.value.description, "99999999999999999999999999999999999998")
        } catch let thrownError {
            XCTFail(thrownError.localizedDescription)
        }
    }

    func testFailsToDecodeANumberWith39Digits() {
        do {
            let jsonData = try self.jsonData(withFileName: "bigint_invalid")
            XCTAssertThrowsError(try self.jsonDecoder.decode(BigIntDummy.self, from: jsonData), "Failed to decode value", { error -> Void in
                switch error {
                case let DecodingError.dataCorrupted(context):
                    XCTAssertEqual(context.debugDescription, "Invalid number")
                default:
                    XCTFail("Should raise a data corrupted error")
                }
            })
        } catch _ {
            XCTFail("Should raise a decoding error")
        }
    }

    func testCustomDateDecodingStrategy() {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .custom({ try dateDecodingStrategy(decoder: $0) })
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
        jsonDecoder.dateDecodingStrategy = .custom({ try dateDecodingStrategy(decoder: $0) })
        do {
            let jsonData = try self.jsonData(withFileName: "dates_invalid")
            _ = try self.jsonDecoder.decode(DateInvalidDummy.self, from: jsonData)
        } catch let error as OMGError {
            XCTAssertEqual(error.message, "unexpected error: Invalid date format")
        } catch _ {
            XCTFail("Unexpected error")
        }
    }

    func testMetadaDecoding() {
        do {
            let jsonData = try self.jsonData(withFileName: "metadata")
            let decodedData = try self.jsonDecoder.decode(MetadataDummy.self, from: jsonData)
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
            let decodedData = try self.jsonDecoder.decode(MetadataDummy.self, from: jsonData)
            XCTAssertTrue(decodedData.metadata!.isEmpty)
        } catch let thrownError {
            XCTFail(thrownError.localizedDescription)
        }
    }

    func testJSONResponseDecoding() {
        do {
            let jsonData = try self.jsonData(withFileName: "json_response")
            let decodedData = try self.jsonDecoder.decode(JSONResponse<[String: String]>.self, from: jsonData)
            XCTAssertEqual(decodedData.version, "1")
            XCTAssertEqual(decodedData.success, true)
            switch decodedData.data {
            case let .success(data: content):
                XCTAssertEqual(content["a_key"], "a_value")
            case let .fail(error: error):
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
                try self.jsonDecoder.decode(JSONResponse<JSONListResponse<String>>.self, from: jsonData)
            XCTAssertEqual(decodedData.version, "1")
            XCTAssertEqual(decodedData.success, true)
            switch decodedData.data {
            case let .success(data: listResponse):
                let list = listResponse.data
                XCTAssertTrue(list.count == 2)
                XCTAssertEqual(list[0], "value_1")
                XCTAssertEqual(list[1], "value_2")
            case let .fail(error: error):
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
                try self.jsonDecoder.decode(JSONResponse<JSONPaginatedListResponse<String>>.self, from: jsonData)
            XCTAssertEqual(decodedData.version, "1")
            XCTAssertEqual(decodedData.success, true)
            switch decodedData.data {
            case let .success(data: listResponse):
                let list = listResponse.data
                XCTAssertTrue(list.count == 2)
                XCTAssertEqual(list[0], "value_1")
                XCTAssertEqual(list[1], "value_2")
                let pagination = listResponse.pagination
                XCTAssertEqual(pagination.currentPage, 1)
                XCTAssertEqual(pagination.perPage, 10)
                XCTAssertEqual(pagination.isFirstPage, true)
                XCTAssertEqual(pagination.isLastPage, true)
            case let .fail(error: error):
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
            XCTAssertEqual(decodedData.socketTopic, "user:cec34607-0761-4a59-8357-18963e42a1aa")
            XCTAssertTrue(decodedData.metadata.isEmpty)
            XCTAssertTrue(decodedData.encryptedMetadata.isEmpty)
            XCTAssertEqual(decodedData.createdAt, try "2018-01-01T00:00:00Z".toDate())
            XCTAssertEqual(decodedData.updatedAt, try "2018-01-01T00:00:00Z".toDate())
        } catch let thrownError {
            XCTFail(thrownError.localizedDescription)
        }
    }

    func testTokenDecoding() {
        do {
            let jsonData = try self.jsonData(withFileName: "token")
            let decodedData = try self.jsonDecoder.decode(Token.self, from: jsonData)
            XCTAssertEqual(decodedData.id, "OMG:123")
            XCTAssertEqual(decodedData.symbol, "OMG")
            XCTAssertEqual(decodedData.name, "OmiseGO")
            XCTAssertEqual(decodedData.subUnitToUnit, 100_000_000)
            XCTAssertTrue(decodedData.metadata.isEmpty)
            XCTAssertTrue(decodedData.encryptedMetadata.isEmpty)
            XCTAssertEqual(decodedData.createdAt, try "2018-01-01T00:00:00Z".toDate())
            XCTAssertEqual(decodedData.updatedAt, try "2018-01-01T00:00:00Z".toDate())
        } catch let thrownError {
            XCTFail(thrownError.localizedDescription)
        }
    }

    func testSettingDecoding() {
        do {
            let jsonData = try self.jsonData(withFileName: "setting")
            let decodedData = try self.jsonDecoder.decode(Setting.self, from: jsonData)
            XCTAssertTrue(decodedData.tokens.count == 1)
            XCTAssertEqual(decodedData.tokens[0].id, "OMG:123")
            XCTAssertEqual(decodedData.tokens[0].symbol, "OMG")
            XCTAssertEqual(decodedData.tokens[0].name, "OmiseGO")
            XCTAssertEqual(decodedData.tokens[0].subUnitToUnit, 100_000_000)
            XCTAssertTrue(decodedData.tokens[0].metadata.isEmpty)
            XCTAssertTrue(decodedData.tokens[0].encryptedMetadata.isEmpty)
            XCTAssertEqual(decodedData.tokens[0].createdAt, try "2018-01-01T00:00:00Z".toDate())
            XCTAssertEqual(decodedData.tokens[0].updatedAt, try "2018-01-01T00:00:00Z".toDate())
        } catch let thrownError {
            XCTFail(thrownError.localizedDescription)
        }
    }

    func testBalanceDecoding() {
        do {
            let jsonData = try self.jsonData(withFileName: "balance")
            let decodedData = try self.jsonDecoder.decode(Balance.self, from: jsonData)
            XCTAssertEqual(decodedData.amount, 103_100)
            XCTAssertEqual(decodedData.token.id, "OMG:123")
            XCTAssertEqual(decodedData.token.symbol, "OMG")
            XCTAssertEqual(decodedData.token.name, "OmiseGO")
            XCTAssertEqual(decodedData.token.subUnitToUnit, 10000)
            XCTAssertTrue(decodedData.token.metadata.isEmpty)
            XCTAssertTrue(decodedData.token.encryptedMetadata.isEmpty)
            XCTAssertEqual(decodedData.token.createdAt, try "2018-01-01T00:00:00Z".toDate())
            XCTAssertEqual(decodedData.token.updatedAt, try "2018-01-01T00:00:00Z".toDate())
        } catch let thrownError {
            XCTFail(thrownError.localizedDescription)
        }
    }

    func testWalletDecoding() {
        do {
            let jsonData = try self.jsonData(withFileName: "wallet")
            let decodedData = try self.jsonDecoder.decode(Wallet.self, from: jsonData)
            XCTAssertEqual(decodedData.address, "2c2e0f2e-fa0f-4abe-8516-9e92cf003486")
            XCTAssertTrue(decodedData.balances.count == 1)
            XCTAssertEqual(decodedData.balances[0].amount, 103_100)
            XCTAssertEqual(decodedData.balances[0].token.id, "OMG:123")
            XCTAssertEqual(decodedData.balances[0].token.symbol, "OMG")
            XCTAssertEqual(decodedData.balances[0].token.name, "OmiseGO")
            XCTAssertEqual(decodedData.balances[0].token.subUnitToUnit, 10000)
            XCTAssertTrue(decodedData.balances[0].token.metadata.isEmpty)
            XCTAssertTrue(decodedData.balances[0].token.encryptedMetadata.isEmpty)
            XCTAssertEqual(decodedData.balances[0].token.createdAt, try "2018-01-01T00:00:00Z".toDate())
            XCTAssertEqual(decodedData.balances[0].token.updatedAt, try "2018-01-01T00:00:00Z".toDate())
            XCTAssertEqual(decodedData.name, "primary")
            XCTAssertEqual(decodedData.identifier, "primary")
            XCTAssertEqual(decodedData.userId!, "cec34607-0761-4a59-8357-18963e42a1aa")
            XCTAssertEqual(decodedData.user!.id, "cec34607-0761-4a59-8357-18963e42a1aa")
            XCTAssertEqual(decodedData.accountId, nil)
            XCTAssertEqual(decodedData.account, nil)
            XCTAssertTrue(decodedData.metadata.isEmpty)
            XCTAssertTrue(decodedData.encryptedMetadata.isEmpty)
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
            XCTAssertEqual(decodedData.token.id, "BTC:861020af-17b6-49ee-a0cb-661a4d2d1f95")
            XCTAssertEqual(decodedData.amount, 1337)
            XCTAssertEqual(decodedData.address, "3b7f1c68-e3bd-4f8f-9916-4af19be95d00")
            let user = decodedData.user!
            XCTAssertEqual(user.id, "6f56efa1-caf9-4348-8e0f-f5af283f17ee")
            XCTAssertNil(decodedData.account)
            XCTAssertEqual(decodedData.correlationId, "31009545-db10-4287-82f4-afb46d9741d8")
            XCTAssertEqual(decodedData.status, .valid)
            XCTAssertEqual(decodedData.socketTopic, "transaction_request:8eb0160e-1c96-481a-88e1-899399cc84dc")
            XCTAssertTrue(decodedData.requireConfirmation)
            XCTAssertEqual(decodedData.maxConsumptions, 1)
            XCTAssertEqual(decodedData.consumptionLifetime, 1000)
            XCTAssertEqual(decodedData.createdAt, "2018-01-01T00:00:00Z".toDate(withFormat: "yyyy-MM-dd'T'HH:mm:ssZ"))
            XCTAssertEqual(decodedData.expirationDate, "2019-01-01T00:00:00Z".toDate(withFormat: "yyyy-MM-dd'T'HH:mm:ssZ"))
            XCTAssertEqual(decodedData.expirationReason, "Expired")
            XCTAssertEqual(decodedData.expiredAt, "2019-01-01T00:00:00Z".toDate(withFormat: "yyyy-MM-dd'T'HH:mm:ssZ"))
            XCTAssertTrue(decodedData.allowAmountOverride)
            XCTAssertEqual(decodedData.exchangeAccountId, "acc_01ca2p8jqans5aty5gj5etmjcf")
            XCTAssertEqual(decodedData.exchangeWalletAddress, "2ae52683-68d8-4af6-94d7-5ed4c34ecf1a")
            XCTAssertEqual(decodedData.exchangeAccount!.id, "acc_01ca2p8jqans5aty5gj5etmjcf")
            XCTAssertEqual(decodedData.exchangeWallet!.address, "2ae52683-68d8-4af6-94d7-5ed4c34ecf1a")
            XCTAssertTrue(decodedData.metadata.isEmpty)
            XCTAssertTrue(decodedData.encryptedMetadata.isEmpty)
        } catch let thrownError {
            XCTFail(thrownError.localizedDescription)
        }
    }

    func testTransactionConsumptionDecoding() {
        do {
            let jsonData = try self.jsonData(withFileName: "transaction_consumption")
            let decodedData = try self.jsonDecoder.decode(TransactionConsumption.self, from: jsonData)
            XCTAssertEqual(decodedData.id, "8eb0160e-1c96-481a-88e1-899399cc84dc")
            XCTAssertEqual(decodedData.status, .confirmed)
            XCTAssertEqual(decodedData.amount, 1337)
            XCTAssertEqual(decodedData.estimatedRequestAmount, 1337)
            XCTAssertEqual(decodedData.estimatedConsumptionAmount, 1337)
            XCTAssertEqual(decodedData.finalizedRequestAmount, 1337)
            XCTAssertEqual(decodedData.finalizedConsumptionAmount, 1337)
            let token = decodedData.token
            XCTAssertEqual(token.id, "BTC:861020af-17b6-49ee-a0cb-661a4d2d1f95")
            XCTAssertEqual(token.symbol, "BTC")
            XCTAssertEqual(token.name, "Bitcoin")
            XCTAssertEqual(token.subUnitToUnit, 100_000)
            XCTAssertEqual(decodedData.correlationId, "31009545-db10-4287-82f4-afb46d9741d8")
            XCTAssertEqual(decodedData.idempotencyToken, "31009545-db10-4287-82f4-afb46d9741d8")
            let transaction = decodedData.transaction!
            XCTAssertEqual(transaction.id, "6ca40f34-6eaa-43e1-b2e1-a94ff366098")
            let user = decodedData.user!
            XCTAssertEqual(user.id, "6f56efa1-caf9-4348-8e0f-f5af283f17ee")
            XCTAssertNil(decodedData.account)
            let transactionRequest = decodedData.transactionRequest
            XCTAssertEqual(transactionRequest.id, "907056a4-fc2d-47cb-af19-5e73aade7ece")
            XCTAssertEqual(decodedData.address, "3b7f1c68-e3bd-4f8f-9916-4af19be95d00")
            XCTAssertEqual(decodedData.socketTopic, "transaction_consumption:8eb0160e-1c96-481a-88e1-899399cc84dc")
            XCTAssertEqual(decodedData.expirationDate, "2019-01-01T00:00:00Z".toDate(withFormat: "yyyy-MM-dd'T'HH:mm:ssZ"))
            XCTAssertEqual(decodedData.approvedAt, "2018-01-02T00:00:00Z".toDate(withFormat: "yyyy-MM-dd'T'HH:mm:ssZ"))
            XCTAssertEqual(decodedData.rejectedAt, nil)
            XCTAssertEqual(decodedData.confirmedAt, "2019-01-02T00:00:00Z".toDate(withFormat: "yyyy-MM-dd'T'HH:mm:ssZ"))
            XCTAssertEqual(decodedData.failedAt, nil)
            XCTAssertEqual(decodedData.expiredAt, nil)
            XCTAssertEqual(decodedData.createdAt, "2018-01-01T00:00:00Z".toDate(withFormat: "yyyy-MM-dd'T'HH:mm:ssZ"))
            XCTAssertEqual(decodedData.exchangeAccountId, "acc_01ca2p8jqans5aty5gj5etmjcf")
            XCTAssertEqual(decodedData.exchangeWalletAddress, "2ae52683-68d8-4af6-94d7-5ed4c34ecf1a")
            XCTAssertEqual(decodedData.exchangeAccount!.id, "acc_01ca2p8jqans5aty5gj5etmjcf")
            XCTAssertEqual(decodedData.exchangeWallet!.address, "2ae52683-68d8-4af6-94d7-5ed4c34ecf1a")
            XCTAssertTrue(decodedData.metadata.isEmpty)
            XCTAssertTrue(decodedData.encryptedMetadata.isEmpty)
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
            let fromToken = from.token
            XCTAssertEqual(fromToken.id, "BTC:xe3982f5-4a27-498d-a91b-7bb2e2a8d3d1")
            XCTAssertEqual(fromToken.symbol, "BTC")
            XCTAssertEqual(fromToken.name, "Bitcoin")
            XCTAssertEqual(fromToken.subUnitToUnit, 100)
            let to = decodedData.to
            XCTAssertEqual(to.address, "2e3982f5-4a27-498d-a91b-7bb2e2a8d3d1")
            let toToken = to.token
            XCTAssertEqual(toToken.id, "BTC:xe3982f5-4a27-498d-a91b-7bb2e2a8d3d1")
            XCTAssertEqual(toToken.symbol, "BTC")
            XCTAssertEqual(toToken.name, "Bitcoin")
            XCTAssertEqual(toToken.subUnitToUnit, 100)
            let exchange = decodedData.exchange
            XCTAssertEqual(exchange.rate, 1)
            XCTAssertEqual(decodedData.status, .confirmed)
            XCTAssertEqual(decodedData.createdAt, "2018-01-01T00:00:00Z".toDate(withFormat: "yyyy-MM-dd'T'HH:mm:ssZ"))
            XCTAssertTrue(decodedData.metadata.isEmpty)
            XCTAssertTrue(decodedData.encryptedMetadata.isEmpty)
            XCTAssertEqual(decodedData.error!.code, .transactionSameAddress)
            XCTAssertEqual(decodedData.error!.description, "Same address")
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
            let token: Token = decodedData.token
            XCTAssertEqual(token.id, "BTC:xe3982f5-4a27-498d-a91b-7bb2e2a8d3d1")
            XCTAssertEqual(token.symbol, "BTC")
            XCTAssertEqual(token.name, "Bitcoin")
            XCTAssertEqual(token.subUnitToUnit, 100)
        } catch let thrownError {
            XCTFail(thrownError.localizedDescription)
        }
    }

    func testTransactionExchangeDecoding() {
        do {
            let jsonData = try self.jsonData(withFileName: "transaction_exchange")
            let decodedData = try self.jsonDecoder.decode(TransactionExchange.self, from: jsonData)
            XCTAssertEqual(decodedData.rate, 0.017)
            XCTAssertEqual(decodedData.calculatedAt, "2018-01-01T00:00:00Z".toDate(withFormat: "yyyy-MM-dd'T'HH:mm:ssZ"))
            XCTAssertEqual(decodedData.exchangePairId!, "exg_01cgvppyrz2pprj6s0zmc26p2p")
            XCTAssertEqual(decodedData.exchangePair!.id, "exg_01cgvppyrz2pprj6s0zmc26p2p")
            XCTAssertEqual(decodedData.exchangeAccountId!, "acc_01CA2P8JQANS5ATY5GJ5ETMJCF")
            XCTAssertEqual(decodedData.exchangeAccount!.id, "acc_01CA2P8JQANS5ATY5GJ5ETMJCF")
            XCTAssertEqual(decodedData.exchangeWalletAddress!, "2c2e0f2e-fa0f-4abe-8516-9e92cf003486")
            XCTAssertEqual(decodedData.exchangeWallet!.address, "2c2e0f2e-fa0f-4abe-8516-9e92cf003486")
        } catch let thrownError {
            XCTFail(thrownError.localizedDescription)
        }
    }

    func testSocketPayloadWithTransactionConsumptionDecoding() {
        do {
            let jsonData = try self.jsonData(withFileName: "socket_response")
            let decodedData = try self.jsonDecoder.decode(SocketPayloadReceive.self, from: jsonData)
            XCTAssertEqual(decodedData.event, SocketEvent.other(event: "an_event"))
            XCTAssertEqual(decodedData.topic, "a_topic")
            XCTAssertEqual(decodedData.ref, "1")
            XCTAssertEqual(decodedData.version, "1")
            XCTAssertEqual(decodedData.success, true)
            switch decodedData.data?.object {
            case let .transactionConsumption(object: transactionConsumption)?: XCTAssertNotNil(transactionConsumption)
            default: XCTFail("Unexpected data")
            }
        } catch let thrownError {
            XCTFail(thrownError.localizedDescription)
        }
    }

    func testSocketPayloadWithErrorDecoding() {
        do {
            let jsonData = try self.jsonData(withFileName: "socket_response_failure")
            let decodedData = try self.jsonDecoder.decode(SocketPayloadReceive.self, from: jsonData)
            XCTAssertEqual(decodedData.event, SocketEvent.other(event: "an_event"))
            XCTAssertEqual(decodedData.topic, "a_topic")
            XCTAssertEqual(decodedData.ref, "1")
            XCTAssertEqual(decodedData.version, "1")
            XCTAssertEqual(decodedData.success, false)
            switch decodedData.error?.code {
            case let .some(code) where code == .invalidParameters: break
            default: XCTFail("Unexpected data")
            }
        } catch let thrownError {
            XCTFail(thrownError.localizedDescription)
        }
    }

    func testSocketPayloadWithUnknownObjectDecoding() {
        do {
            let jsonData = try self.jsonData(withFileName: "socket_response_unknown_object")
            let decodedData = try self.jsonDecoder.decode(SocketPayloadReceive.self, from: jsonData)
            XCTAssertEqual(decodedData.event, SocketEvent.other(event: "an_event"))
            XCTAssertEqual(decodedData.topic, "a_topic")
            XCTAssertEqual(decodedData.ref, "1")
            XCTAssertEqual(decodedData.version, "1")
            XCTAssertEqual(decodedData.success, true)
            switch decodedData.data?.object {
            case let .error(error: error)?: XCTAssertEqual(error.message, "socket error: Invalid payload")
            default: XCTFail("Unexpected data")
            }
        } catch let thrownError {
            XCTFail(thrownError.localizedDescription)
        }
    }

    func testAccountDecoding() {
        do {
            let jsonData = try self.jsonData(withFileName: "account")
            let decodedData = try self.jsonDecoder.decode(Account.self, from: jsonData)
            XCTAssertEqual(decodedData.id, "acc_01CA2P8JQANS5ATY5GJ5ETMJCF")
            XCTAssertEqual(decodedData.parentId, "acc_01CA26PKGE49AABZD6K6MSHN0Y")
            XCTAssertEqual(decodedData.name, "Account Name")
            XCTAssertEqual(decodedData.description, "The account description")
            XCTAssertEqual(decodedData.isMaster, false)
            let avatar = decodedData.avatar
            XCTAssertEqual(avatar.original, "original_url")
            XCTAssertTrue(decodedData.metadata.isEmpty)
            XCTAssertTrue(decodedData.encryptedMetadata.isEmpty)
            XCTAssertEqual(decodedData.createdAt, "2018-01-01T00:00:00Z".toDate(withFormat: "yyyy-MM-dd'T'HH:mm:ssZ"))
            XCTAssertEqual(decodedData.updatedAt, "2018-01-01T10:00:00Z".toDate(withFormat: "yyyy-MM-dd'T'HH:mm:ssZ"))
        } catch let thrownError {
            XCTFail(thrownError.localizedDescription)
        }
    }

    func testAvatarDecoding() {
        do {
            let jsonData = try self.jsonData(withFileName: "avatar")
            let decodedData = try self.jsonDecoder.decode(Avatar.self, from: jsonData)
            XCTAssertEqual(decodedData.original, "original_url")
            XCTAssertEqual(decodedData.large, "large_url")
            XCTAssertEqual(decodedData.small, "small_url")
            XCTAssertEqual(decodedData.thumb, "thumb_url")
        } catch let thrownError {
            XCTFail(thrownError.localizedDescription)
        }
    }

    func testExchangePairDecoding() {
        do {
            let jsonData = try self.jsonData(withFileName: "exchange_pair")
            let decodedData = try self.jsonDecoder.decode(ExchangePair.self, from: jsonData)
            XCTAssertEqual(decodedData.id, "exg_01cgvppyrz2pprj6s0zmc26p2p")
            XCTAssertEqual(decodedData.name, "ETH/OMG")
            XCTAssertEqual(decodedData.fromTokenId, "tok_ETH_01cbfge9qhmsdbjyb7a8e8pxt3")
            XCTAssertEqual(decodedData.fromToken.id, "tok_ETH_01cbfge9qhmsdbjyb7a8e8pxt3")
            XCTAssertEqual(decodedData.toTokenId, "tok_OMG_01cgvrqbfpa23ehkmrtqpbsyyp")
            XCTAssertEqual(decodedData.toToken.id, "tok_OMG_01cgvrqbfpa23ehkmrtqpbsyyp")
            XCTAssertEqual(decodedData.rate, 0.017)
            XCTAssertEqual(decodedData.createdAt, "2018-01-01T00:00:00Z".toDate(withFormat: "yyyy-MM-dd'T'HH:mm:ssZ"))
            XCTAssertEqual(decodedData.updatedAt, "2018-01-01T10:00:00Z".toDate(withFormat: "yyyy-MM-dd'T'HH:mm:ssZ"))
        } catch let thrownError {
            XCTFail(thrownError.localizedDescription)
        }
    }
}
