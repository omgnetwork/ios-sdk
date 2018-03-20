//
//  QRReaderTest.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 12/2/2018.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

import XCTest
@testable import OmiseGO
import AVFoundation

class QRReaderTest: XCTestCase {

    func testCallbackIsCalled() {
        let reader = MockQRReader { (value) in
            XCTAssertEqual(value, "123")
        }
        reader.mockValueFound(value: "123")
    }

    func testIsAvailable() {
        XCTAssertFalse(QRReader.isAvailable())
    }

}
