//
//  QRReaderTest.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 12/2/2018 BE.
//  Copyright © 2018 OmiseGO. All rights reserved.
//

import XCTest
@testable import OmiseGO

class QRReaderTest: XCTestCase {

    func testCallbackIsCalled() {
        let reader = MockQRReader { (value) in
            XCTAssertEqual(value, "123")
        }
        reader.mockValueFound(value: "123")
    }

}
