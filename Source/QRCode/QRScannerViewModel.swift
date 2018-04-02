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
typealias OnErrorClosure = ((OmiseGOError) -> Void)

protocol QRScannerViewModelProtocol {
    var onLoadingStateChange: LoadingClosure? { get set }
    var onGetTransactionRequest: OnGetTransactionRequestClosure? { get set }
    var onError: OnErrorClosure? { get set }
    func startScanning()
    func stopScanning()
    func readerPreviewLayer() -> AVCaptureVideoPreviewLayer
    func updateQRReaderPreviewLayer(withFrame frame: CGRect)
    func isQRCodeAvailable() -> Bool
    func loadTransactionRequest(withId id: String)
}

class QRScannerViewModel: QRScannerViewModelProtocol {

    var onLoadingStateChange: LoadingClosure?
    var onGetTransactionRequest: OnGetTransactionRequestClosure?
    var onError: OnErrorClosure?
    var loadedIds: [String] = []

    private lazy var reader: QRReader = {
        QRReader(onFindClosure: { [weak self] (value) in
            DispatchQueue.main.async {
                self?.loadTransactionRequest(withId: value)
            }
        })
    }()
    private let client: OMGHTTPClient

    init(client: OMGHTTPClient) {
        self.client = client
    }

    func loadTransactionRequest(withId id: String) {
        // prevent from loading multiple time the same id
        guard !self.loadedIds.contains(id) else { return }
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
        self.loadedIds.append(id)
        self.stopScanning()
        self.onLoadingStateChange?(true)
        TransactionRequest.retrieveTransactionRequest(using: self.client, id: id) { (result) in
            self.startScanning()
            self.onLoadingStateChange?(false)
            switch result {
            case .success(data: let transactionRequest):
                // Allows to scan the same id again only if was valid
                if let index = self.loadedIds.index(of: id) { self.loadedIds.remove(at: index) }
                self.onGetTransactionRequest?(transactionRequest)
            case .fail(error: let error): self.onError?(error)
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
