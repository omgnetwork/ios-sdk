//
//  TestQRReader.swift
//  Tests
//
//  Created by Mederic Petit on 12/2/2018.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

@testable import OmiseGO
import XCTest

class TestQRReader: QRReader {
    func mockValueFound(value: String) {
        self.delegate?.onDecodedData(decodedData: value)
    }
}

class TestQRVCDelegate: QRScannerViewControllerDelegate {
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

    func userDidChoosePermission(granted _: Bool) {}
}

import AVFoundation

class TestQRViewModel: QRScannerViewModelProtocol {
    var didStartScanning: Bool = false
    var didStopScanning: Bool = false
    var didUpdateQRReaderPreviewLayer: Bool = false
    var didCallLoadTransactionRequestWithFormattedId: Bool = false

    var onLoadingStateChange: LoadingClosure?

    var onGetTransactionRequest: OnGetTransactionRequestClosure?

    var onUserPermissionChoice: ((Bool) -> Void)?

    var onError: OnErrorClosure?

    func startScanning(onStart _: (() -> Void)?) {
        self.didStartScanning = true
    }

    func stopScanning(onStop _: (() -> Void)?) {
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

class TestQRVerifier: QRVerifier {
    let success: Bool

    init(success: Bool) {
        self.success = success
    }

    func onData(data _: String, callback: @escaping (Response<TransactionRequest>) -> Void) {
        if self.success {
            callback(Response.success(data: StubGenerator.transactionRequest()))
        } else {
            callback(Response.fail(error: OMGError.api(apiError: .init(code: .other("test"), description: "test"))))
        }
    }
}
