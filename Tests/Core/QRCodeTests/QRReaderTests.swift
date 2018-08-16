//
//  QRReaderTests.swift
//  Tests
//
//  Created by Mederic Petit on 12/2/2018.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

import AVFoundation
@testable import OmiseGO
import XCTest

class QRReaderTest: XCTestCase {
    func testCallbackIsCalled() {
        let reader = TestQRReader { value in
            XCTAssertEqual(value, "123")
        }
        reader.mockValueFound(value: "123")
    }

    func testIsAvailable() {
        XCTAssertFalse(QRReader.isAvailable())
    }
}
