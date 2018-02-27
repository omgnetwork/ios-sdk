//
//  MockQRReader.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 12/2/2018 BE.
//  Copyright © 2018 OmiseGO. All rights reserved.
//
// swiftlint:disable identifier_name

import XCTest
@testable import OmiseGO

class MockQRReader: QRReader {

    func mockValueFound(value: String) {
        self.didReadCode(value)
    }

}

class MockQRVCDelegate: QRScannerViewControllerDelegate {

    var asyncExpectation: XCTestExpectation?

    var didCancel: Bool = false
    var transactionRequest: TransactionRequest?
    var error: OmiseGOError?

    init(asyncExpectation: XCTestExpectation? = nil) {
        self.asyncExpectation = asyncExpectation
    }

    func scannerDidCancel(scanner: QRScannerViewController) {
        self.didCancel = true
        self.asyncExpectation?.fulfill()
    }

    func scannerDidDecode(scanner: QRScannerViewController, transactionRequest: TransactionRequest) {
        self.transactionRequest = transactionRequest
        self.asyncExpectation?.fulfill()
    }

    func scannerDidFailToDecode(scanner: QRScannerViewController, withError error: OmiseGOError) {
        self.error = error
        self.asyncExpectation?.fulfill()
    }

}

import AVFoundation

class MockQRViewModel: QRScannerViewModelProtocol {

    var didStartScanning: Bool = false
    var didStopScanning: Bool = false
    var didUpdateQRReaderPreviewLayer: Bool = false
    var didCallLoadTransactionRequestWithId: Bool = false

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

    func updateQRReaderPreviewLayer(withFrame frame: CGRect) {
        self.didUpdateQRReaderPreviewLayer = true
    }

    func isQRCodeAvailable() -> Bool {
        return true // for testing purpose we ignore the availabilty of the video device
    }

    func loadTransactionRequest(withId id: String) {
        self.didCallLoadTransactionRequestWithId = true
    }
}
