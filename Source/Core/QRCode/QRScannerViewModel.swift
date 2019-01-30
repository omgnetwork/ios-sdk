//
//  QRScannerViewModel.swift
//  OmiseGO
//
//  Created by Mederic Petit on 9/2/2018.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

import AVFoundation

typealias LoadingClosure = ((Bool) -> Void)
typealias OnGetTransactionRequestClosure = ((TransactionRequest) -> Void)
typealias OnErrorClosure = ((OMGError) -> Void)

protocol QRScannerViewModelProtocol {
    var onLoadingStateChange: LoadingClosure? { get set }
    var onGetTransactionRequest: OnGetTransactionRequestClosure? { get set }
    var onError: OnErrorClosure? { get set }
    func startScanning()
    func stopScanning()
    func readerPreviewLayer() -> AVCaptureVideoPreviewLayer
    func updateQRReaderPreviewLayer(withFrame frame: CGRect)
    func isQRCodeAvailable() -> Bool
    func loadTransactionRequest(withFormattedId formattedId: String)
}

class QRScannerViewModel: QRScannerViewModelProtocol {
    var onLoadingStateChange: LoadingClosure?
    var onGetTransactionRequest: OnGetTransactionRequestClosure?
    var onError: OnErrorClosure?
    var loadedIds: [String] = []

    private lazy var reader: QRReader = {
        QRReader(onFindClosure: { [weak self] value in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.loadTransactionRequest(withFormattedId: value)
            }
        })
    }()

    private let verifier: QRVerifier

    init(verifier: QRVerifier) {
        self.verifier = verifier
    }

    func loadTransactionRequest(withFormattedId formattedId: String) {
        // prevent from loading multiple time the same id
        guard !self.loadedIds.contains(formattedId) else { return }
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
        self.loadedIds.append(formattedId)
        self.stopScanning()
        self.onLoadingStateChange?(true)
        self.verifier.onData(data: formattedId) { [weak self] result in
            guard let self = self else { return }
            self.onLoadingStateChange?(false)
            switch result {
            case let .success(data: transactionRequest):
                self.onGetTransactionRequest?(transactionRequest)
            case let .fail(error: error):
                self.startScanning()
                self.onError?(error)
            }
        }
    }

    func startScanning() {
        self.reader.startScanning()
    }

    func stopScanning() {
        self.reader.stopScanning()
    }

    func readerPreviewLayer() -> AVCaptureVideoPreviewLayer {
        return self.reader.previewLayer
    }

    func updateQRReaderPreviewLayer(withFrame frame: CGRect) {
        self.reader.previewLayer.frame = frame
    }

    func isQRCodeAvailable() -> Bool {
        return QRReader.isAvailable()
    }
}
