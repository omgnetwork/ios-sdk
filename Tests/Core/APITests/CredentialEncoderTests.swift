//
//  CredentialEncoderTests.swift
//  Tests
//
//  Created by Mederic Petit on 9/8/18.
//  Copyright © 2017-2019 Omise Go Pte. Ltd. All rights reserved.
//

@testable import OmiseGO
import XCTest

class CredentialEncoderTests: XCTestCase {
    func testEncodeAuthorizationHeaderCorrectly() {
        XCTAssertEqual(
            try! CredentialEncoder.encode(value1: "123", value2: "123", scheme: "OMGClient"),
            "OMGClient \("123:123".data(using: .utf8)!.base64EncodedString())"
        )
    }
}
