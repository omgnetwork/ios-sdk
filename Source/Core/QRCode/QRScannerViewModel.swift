//
//  QRScannerViewModel.swift
//  OmiseGO
//
//  Created by Mederic Petit on 9/2/2018.
//  Copyright © 2017-2019 Omise Go Pte. Ltd. All rights reserved.
//

import AVFoundation

typealias LoadingClosure = ((Bool) -> Void)
typealias OnGetTransactionRequestClosure = ((TransactionRequest) -> Void)
typealias OnErrorClosure = ((OMGError) -> Void)

protocol QRScannerViewModelProtocol {
    var onLoadingStateChange: LoadingClosure? { get set }
    var onGetTransactionRequest: OnGetTransactionRequestClosure? { get set }
    var onUserPermissionChoice: ((Bool) -> Void)? { get set }
    var onError: OnErrorClosure? { get set }
    func startScanning(onStart: (() -> Void)?)
    func stopScanning(onStop: (() -> Void)?)
    func readerPreviewLayer() -> AVCaptureVideoPreviewLayer
    func updateQRReaderPreviewLayer(withFrame frame: CGRect)
    func isQRCodeAvailable() -> Bool
    func loadTransactionRequest(withFormattedId formattedId: String)
}

class QRScannerViewModel: QRScannerViewModelProtocol {
    var onLoadingStateChange: LoadingClosure?
    var onGetTransactionRequest: OnGetTransactionRequestClosure?
    var onUserPermissionChoice: ((Bool) -> Void)?
    var onError: OnErrorClosure?
    var loadedIds: [String] = []

    private lazy var reader: QRReader = {
        QRReader(delegate: self)
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
        self.onLoadingStateChange?(true)
        self.stopScanning { [weak self] in
            guard let self = self else { return }
            self.verifier.onData(data: formattedId) { [weak self] result in
                guard let self = self else { return }
                self.onLoadingStateChange?(false)
                switch result {
                case let .success(transactionRequest):
                    self.loadedIds = self.loadedIds.filter { $0 != formattedId }
                    self.onGetTransactionRequest?(transactionRequest)
                case let .failure(error):
                    self.startScanning()
                    self.onError?(error)
                }
            }
        }
    }

    func startScanning(onStart: (() -> Void)? = nil) {
        self.reader.startScanning(onStart: onStart)
    }

    func stopScanning(onStop: (() -> Void)? = nil) {
        self.reader.stopScanning(onStop: onStop)
    }

    func readerPreviewLayer() -> AVCaptureVideoPreviewLayer {
        return self.reader.previewLayer
    }

    func updateQRReaderPreviewLayer(withFrame frame: CGRect) {
        self.reader.previewLayer.frame = frame
    }

    func isQRCodeAvailable() -> Bool {
        return self.reader.isAvailable()
    }
}

extension QRScannerViewModel: QRReaderDelegate {
    func onDecodedData(decodedData: String) {
        self.loadTransactionRequest(withFormattedId: decodedData)
    }

    func onUserPermissionChoice(granted: Bool) {
        self.onUserPermissionChoice?(granted)
    }
}
