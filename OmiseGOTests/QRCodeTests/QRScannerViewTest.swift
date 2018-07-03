//
//  QRScannerViewTest.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 7/3/18.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

@testable import OmiseGO
import XCTest

class QRScannerViewTest: XCTestCase {
    func testInitWithCoder() {
        XCTAssertNil(QRScannerView(coder: NSCoder()))
    }

    func testInitWithFrame() {
        let frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        let layer = CALayer()
        let view = QRScannerView(frame: frame, readerPreviewLayer: layer)
        XCTAssertEqual(view.frame, frame)
        XCTAssertEqual(view.readerPreviewLayer, layer)
    }

    func testLayoutSubviews() {
        let frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        let layer = CALayer()
        let view = QRScannerView(frame: frame, readerPreviewLayer: layer)
        XCTAssertEqual(layer.frame, CGRect(x: 0, y: 0, width: 0, height: 0))
        view.layoutSubviews()
        XCTAssertEqual(layer.frame, frame)
    }

    func testSetup() {
        let frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        let layer = CALayer()
        let view = QRScannerView(frame: frame, readerPreviewLayer: layer)
        view.setup()
        XCTAssertTrue(view.subviews.contains(view.cameraView))
        XCTAssertTrue(view.subviews.contains(view.overlayView))
        XCTAssertTrue(view.subviews.contains(view.cancelButton))
    }
}
