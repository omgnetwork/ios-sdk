//
//  QRGeneratorTests.swift
//  Tests
//
//  Created by Mederic Petit on 6/2/2018.
//  Copyright © 2017-2019 Omise Go Pte. Ltd. All rights reserved.
//

@testable import OmiseGO
import XCTest

class QRGeneratorTest: XCTestCase {
    func testImageSize() {
        let data = "Test data".data(using: .isoLatin1)!
        if let qrCode = QRGenerator.generateQRCode(fromData: data, outputSize: CGSize(width: 150, height: 150)) {
            XCTAssertEqual(qrCode.size.width, 150)
            XCTAssertEqual(qrCode.size.height, 150)
        } else {
            XCTFail("Failed to generate the qrCode")
        }
    }

    func testGeneratedQRCodeContainsInputText() {
        let inputText = "Test data"
        let data = inputText.data(using: .isoLatin1)!
        if let qrCode = QRGenerator.generateQRCode(fromData: data, outputSize: CGSize(width: 200, height: 200)) {
            let decodedText = TestQRHelper.readQRCode(fromImage: qrCode)
            XCTAssertEqual(decodedText, inputText)
        } else {
            XCTFail("Failed to generate the qrCode")
        }
    }
}
