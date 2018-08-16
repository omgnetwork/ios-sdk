//
//  QRScannerViewModelTests.swift
//  Tests
//
//  Created by Mederic Petit on 12/2/2018.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

@testable import OmiseGO
import XCTest

class QRScannerViewModelTest: FixtureTestCase {
    func testCallsOnGetTransactionRequestWhenDecodingATransactionRequest() {
        let exp = expectation(description: "Calls onGetTransactionRequest when scanning a valid QRCode")
        let verifier = TestQRVerifier(success: true)
        let stub = QRScannerViewModel(verifier: verifier)
        stub.onGetTransactionRequest = { transactionRequest in
            defer { exp.fulfill() }
            XCTAssertNotNil(transactionRequest)
        }
        stub.loadTransactionRequest(withFormattedId: "|123")
        waitForExpectations(timeout: 1, handler: nil)
    }

    func testCallsOnErrorWithTheAPIErrorWhenFailingToDecodeATransactionRequest() {
        let exp = expectation(description: "Calls onError when scanning a valid QRCode with an invalid transaction request")
        let verifier = TestQRVerifier(success: false)
        let stub = QRScannerViewModel(verifier: verifier)
        stub.onError = { error in
            defer { exp.fulfill() }
            XCTAssertNotNil(error)
            XCTAssertEqual(error.message, "test")
        }
        stub.loadTransactionRequest(withFormattedId: "|123")
        waitForExpectations(timeout: 1, handler: nil)
    }

    func testDoesntCallWithTheSameIdTwiceIfCallFailed() {
        let exp = expectation(description: "Doesn't call API with the same id twice if the previous call failed")
        let verifier = TestQRVerifier(success: false)
        let stub = QRScannerViewModel(verifier: verifier)
        stub.onError = { error in
            defer { exp.fulfill() }
            XCTAssert(stub.loadedIds.contains("|123"))
            XCTAssertNotNil(error)
            stub.loadTransactionRequest(withFormattedId: "|123")
        }
        stub.loadTransactionRequest(withFormattedId: "|123")
        waitForExpectations(timeout: 1, handler: nil)
    }

    func testCallsOnLoadingStateChangeWhenRequesting() {
        let exp = expectation(description: "Calls onGetTransactionRequest when scanning a valid QRCode")
        let verifier = TestQRVerifier(success: true)
        let stub = QRScannerViewModel(verifier: verifier)
        var counter = 0
        stub.onLoadingStateChange = { loading in
            if counter == 0 {
                XCTAssert(loading)
                counter += 1
            } else if counter == 1 {
                XCTAssert(!loading)
                exp.fulfill()
            }
        }
        stub.loadTransactionRequest(withFormattedId: "|123")
        waitForExpectations(timeout: 1, handler: nil)
    }
}
