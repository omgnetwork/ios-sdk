//
//  TransactionRequestTest.swift
//  Tests
//
//  Created by Mederic Petit on 5/2/2018.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

import OmiseGO
import XCTest

class TransactionRequestTest: XCTestCase {
    func testQRCodeImage() {
        let transactionRequest = StubGenerator.transactionRequest()
        if let qrImage = transactionRequest.qrImage() {
            let decodedText = TestQRHelper.readQRCode(fromImage: qrImage)
            XCTAssertEqual(decodedText, transactionRequest.formattedId)
        } else {
            XCTFail("QR image should not be nil")
        }
    }

    func testEquatable() {
        let transactionRequest1 = StubGenerator.transactionRequest(id: "1")
        let transactionRequest2 = StubGenerator.transactionRequest(id: "1")
        let transactionRequest3 = StubGenerator.transactionRequest(id: "2")
        XCTAssertEqual(transactionRequest1, transactionRequest2)
        XCTAssertNotEqual(transactionRequest1, transactionRequest3)
    }

    func testHashable() {
        let transactionRequest1 = StubGenerator.transactionRequest(id: "1")
        let transactionRequest2 = StubGenerator.transactionRequest(id: "1")
        let set: Set<TransactionRequest> = [transactionRequest1, transactionRequest2]
        XCTAssertEqual(transactionRequest1.hashValue, "1".hashValue)
        XCTAssertEqual(set.count, 1)
    }
}
