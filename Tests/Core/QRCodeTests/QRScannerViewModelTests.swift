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
        let sut = QRScannerViewModel(verifier: verifier)
        sut.onGetTransactionRequest = { transactionRequest in
            defer { exp.fulfill() }
            XCTAssertNotNil(transactionRequest)
        }
        sut.loadTransactionRequest(withFormattedId: "|123")
        waitForExpectations(timeout: 1, handler: nil)
    }

    func testCallsOnErrorWithTheAPIErrorWhenFailingToDecodeATransactionRequest() {
        let exp = expectation(description: "Calls onError when scanning a valid QRCode with an invalid transaction request")
        let verifier = TestQRVerifier(success: false)
        let sut = QRScannerViewModel(verifier: verifier)
        sut.onError = { error in
            defer { exp.fulfill() }
            XCTAssertNotNil(error)
            XCTAssertEqual(error.message, "test")
        }
        sut.loadTransactionRequest(withFormattedId: "|123")
        waitForExpectations(timeout: 1, handler: nil)
    }

    func testDoesntCallWithTheSameIdTwiceIfCallFailed() {
        let exp = expectation(description: "Doesn't call API with the same id twice if the previous call failed")
        let verifier = TestQRVerifier(success: false)
        let sut = QRScannerViewModel(verifier: verifier)
        sut.onError = { error in
            defer { exp.fulfill() }
            XCTAssert(sut.loadedIds.contains("|123"))
            XCTAssertNotNil(error)
            sut.loadTransactionRequest(withFormattedId: "|123")
        }
        sut.loadTransactionRequest(withFormattedId: "|123")
        waitForExpectations(timeout: 1, handler: nil)
    }

    func testCanDecodeAValidIdMultipleTimes() {
        let exp = expectation(description: "Can decode a valid Id multiple times")
        exp.expectedFulfillmentCount = 2
        let verifier = TestQRVerifier(success: true)
        let sut = QRScannerViewModel(verifier: verifier)
        var counter = 0
        sut.onGetTransactionRequest = { _ in
            counter += 1
            exp.fulfill()
            if counter < 2 {
                sut.loadTransactionRequest(withFormattedId: "|123")
            }
        }
        sut.loadTransactionRequest(withFormattedId: "|123")
        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertEqual(counter, 2)
    }

    func testCallsOnLoadingStateChangeWhenRequesting() {
        let exp = expectation(description: "Calls onGetTransactionRequest when scanning a valid QRCode")
        let verifier = TestQRVerifier(success: true)
        let sut = QRScannerViewModel(verifier: verifier)
        var counter = 0
        sut.onLoadingStateChange = { loading in
            if counter == 0 {
                XCTAssert(loading)
                counter += 1
            } else if counter == 1 {
                XCTAssert(!loading)
                exp.fulfill()
            }
        }
        sut.loadTransactionRequest(withFormattedId: "|123")
        waitForExpectations(timeout: 1, handler: nil)
    }
}
