//
//  QRScannerViewModelTest.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 12/2/2018.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

import XCTest
@testable import OmiseGO

class QRScannerViewModelTest: FixtureTestCase {

    func testCallsOnGetTransactionRequest() {
        let exp = expectation(description: "Calls onGetTransactionRequest when scanning a valid QRCode")
        let stub = QRScannerViewModel(client: self.testCustomClient)
        stub.onGetTransactionRequest = { (transactionRequest) in
            defer { exp.fulfill() }
            XCTAssertNotNil(transactionRequest)
        }
        stub.loadTransactionRequest(withId: "123")
        waitForExpectations(timeout: 1, handler: nil)
    }

    func testDoesntCallWithTheSameIdTwiceIfCallFailed() {
        let exp = expectation(description: "Doesn't call API with the same id twice if the previous call failed")
        let stub = QRScannerViewModel(client:
            OMGHTTPClient(config: OMGConfiguration(baseURL: "", apiKey: "", authenticationToken: "")))
        stub.onError = { (error) in
            defer { exp.fulfill() }
            XCTAssert(stub.loadedIds.contains("123"))
            XCTAssertNotNil(error)
            stub.loadTransactionRequest(withId: "123")
        }
        stub.loadTransactionRequest(withId: "123")
        waitForExpectations(timeout: 1, handler: nil)
    }

    func testCanCallTwiceIfCallSucceeded() {
        let exp = expectation(description: "Can call with the same id twice if the previous call succeeded")
        let stub = QRScannerViewModel(client: self.testCustomClient)
        var counter = 0
        stub.onGetTransactionRequest = { (transactionRequest) in
            counter += 1
            XCTAssert(!stub.loadedIds.contains("123"))
            XCTAssertNotNil(transactionRequest)
            if counter == 2 {
                exp.fulfill()
            } else { stub.loadTransactionRequest(withId: "123") }
        }
        stub.loadTransactionRequest(withId: "123")
        waitForExpectations(timeout: 1, handler: nil)
    }

    func testCallsOnLoadingStateChangeWhenRequesting() {
        let exp = expectation(description: "Calls onGetTransactionRequest when scanning a valid QRCode")
        let stub = QRScannerViewModel(client: self.testCustomClient)
        var counter = 0
        stub.onLoadingStateChange = { (loading) in
            if counter == 0 {
                XCTAssert(loading)
                counter += 1
            } else if counter == 1 {
                XCTAssert(!loading)
                exp.fulfill()
            }
        }
        stub.loadTransactionRequest(withId: "123")
        waitForExpectations(timeout: 1, handler: nil)
    }

}
