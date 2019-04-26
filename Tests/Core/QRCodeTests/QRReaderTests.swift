//
//  QRReaderTests.swift
//  Tests
//
//  Created by Mederic Petit on 12/2/2018.
//  Copyright © 2017-2019 Omise Go Pte. Ltd. All rights reserved.
//

import AVFoundation
@testable import OmiseGO
import XCTest

class QRReaderTest: XCTestCase {
    func testCallbackIsCalled() {
        let e = self.expectation(description: "calls delegate when decoding data")
        let delegate = DummyQRReaderDelegate(ex: e)
        let reader = TestQRReader(delegate: delegate)
        reader.mockValueFound(value: "123")
        waitForExpectations(timeout: 1, handler: nil)
        XCTAssertEqual(delegate.decodedData, "123")
    }
}

class DummyQRReaderDelegate: QRReaderDelegate {
    let e: XCTestExpectation
    var decodedData: String?

    init(ex: XCTestExpectation) {
        self.e = ex
    }

    func onDecodedData(decodedData: String) {
        self.decodedData = decodedData
        self.e.fulfill()
    }

    func onUserPermissionChoice(granted _: Bool) {}
}
