//
//  MockQRReader.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 12/2/2018.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

@testable import OmiseGO
import XCTest

class MockQRReader: QRReader {
    func mockValueFound(value: String) {
        self.didReadCode(value)
    }
}

class MockQRVCDelegate: QRScannerViewControllerDelegate {
    var asyncExpectation: XCTestExpectation?

    var didCancel: Bool = false
    var transactionRequest: TransactionRequest?
    var error: OMGError?

    init(asyncExpectation: XCTestExpectation? = nil) {
        self.asyncExpectation = asyncExpectation
    }

    func scannerDidCancel(scanner _: QRScannerViewController) {
        self.didCancel = true
        self.asyncExpectation?.fulfill()
    }

    func scannerDidDecode(scanner _: QRScannerViewController, transactionRequest: TransactionRequest) {
        self.transactionRequest = transactionRequest
        self.asyncExpectation?.fulfill()
    }

    func scannerDidFailToDecode(scanner _: QRScannerViewController, withError error: OMGError) {
        self.error = error
        self.asyncExpectation?.fulfill()
    }
}

import AVFoundation

class MockQRViewModel: QRScannerViewModelProtocol {
    var didStartScanning: Bool = false
    var didStopScanning: Bool = false
    var didUpdateQRReaderPreviewLayer: Bool = false
    var didCallLoadTransactionRequestWithFormattedId: Bool = false

    var onLoadingStateChange: LoadingClosure?

    var onGetTransactionRequest: OnGetTransactionRequestClosure?

    var onError: OnErrorClosure?

    func startScanning() {
        self.didStartScanning = true
    }

    func stopScanning() {
        self.didStopScanning = true
    }

    func readerPreviewLayer() -> AVCaptureVideoPreviewLayer {
        return AVCaptureVideoPreviewLayer()
    }

    func updateQRReaderPreviewLayer(withFrame _: CGRect) {
        self.didUpdateQRReaderPreviewLayer = true
    }

    func isQRCodeAvailable() -> Bool {
        return true // for testing purpose we ignore the availabilty of the video device
    }

    func loadTransactionRequest(withFormattedId _: String) {
        self.didCallLoadTransactionRequestWithFormattedId = true
    }
}
