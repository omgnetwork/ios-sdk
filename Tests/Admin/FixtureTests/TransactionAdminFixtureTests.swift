//
//  TransactionAdminFixtureTests.swift
//  Tests
//
//  Created by Mederic Petit on 19/9/18.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

import OmiseGO
import XCTest

class TransactionAdminFixtureTests: FixtureAdminTestCase {
    func testGetListOfTransactions() {
        let expectation = self.expectation(description: "Get the list of transactions")
        let params = PaginatedListParams<Transaction>(page: 1,
                                                      perPage: 10,
                                                      sortBy: .to,
                                                      sortDirection: .ascending)
        let request =
            Transaction.list(using: self.testClient, params: params) { result in
                defer { expectation.fulfill() }
                switch result {
                case let .success(data: paginatedList):
                    let transactions = paginatedList.data
                    XCTAssertEqual(transactions.first?.id, "txn_01cqr309xnwa2qwdk4dqaqrbs6")
                    XCTAssertEqual(transactions[1].id, "txn_01cqr2yx2ns2kdysat3h7075a0")
                case let .fail(error: error):
                    XCTFail("\(error)")
                }
            }
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }

    func testCreateTransaction() {
        let expectation = self.expectation(description: "Create a transaction")
        let params = TransactionCreateParams(fromAddress: "dqhg022708121978",
                                             toAddress: "iciu825817955943",
                                             amount: nil,
                                             fromAmount: nil,
                                             toAmount: 200,
                                             fromTokenId: "tok_NT2_01cqx98daqa6qf0pdzn3e5csjq",
                                             toTokenId: "tok_NTN_01cqx8vhhj1h9mb1mw8hj5vs48",
                                             tokenId: nil,
                                             fromAccountId: "acc_01cqwwqz8zpsgta8rsm244w8rr",
                                             toAccountId: "acc_01cqx8qt9hgnbz1vkwhm5ymkbn",
                                             fromProviderUserId: nil,
                                             toProviderUserId: nil,
                                             fromUserId: nil,
                                             toUserId: nil,
                                             idempotencyToken: "82492734829374",
                                             exchangeAccountId: "acc_01cqwwqz8zpsgta8rsm244w8rr",
                                             exchangeAddress: "dqhg022708121978",
                                             metadata: ["a_key": "a_value"],
                                             encryptedMetadata: ["a_key": "a_value"])
        let request = Transaction.create(using: self.testClient, params: params) { result in
            defer { expectation.fulfill() }
            switch result {
            case let .success(data: transaction):
                XCTAssertEqual(transaction.from.account!.id, "acc_01cqwwqz8zpsgta8rsm244w8rr")
                XCTAssertEqual(transaction.to.account!.id, "acc_01cqx8qt9hgnbz1vkwhm5ymkbn")
                XCTAssertEqual(transaction.from.address, "dqhg022708121978")
                XCTAssertEqual(transaction.to.address, "iciu825817955943")
                XCTAssertEqual(transaction.from.token.id, "tok_NT2_01cqx98daqa6qf0pdzn3e5csjq")
                XCTAssertEqual(transaction.to.token.id, "tok_NTN_01cqx8vhhj1h9mb1mw8hj5vs48")
                XCTAssertEqual(transaction.exchange.exchangeAccountId!, "acc_01cqwwqz8zpsgta8rsm244w8rr")
                XCTAssertEqual(transaction.exchange.exchangeWalletAddress!, "dqhg022708121978")
            case let .fail(error: error):
                XCTFail("\(error)")
            }
        }
        XCTAssertNotNil(request)
        waitForExpectations(timeout: 15.0, handler: nil)
    }
}
