//
//  QRScannerViewController+Client.swift
//  OmiseGO
//
//  Created by Mederic Petit on 8/8/18.
//  Copyright © 2017-2019 Omise Go Pte. Ltd. All rights reserved.
//

extension QRScannerViewController {
    /// Initialize the QR code scanner. You should always use this method to initialize it.
    ///
    /// - Parameters:
    ///   - delegate: The delegate that will receive the events from the scanner
    ///   - verifier: A QRClientVerifier that will take care of processing the scanned data
    ///   - cancelButtonTitle: The title of the cancel button
    /// - Returns: An optional cancellable request.
    public convenience init?(delegate: QRScannerViewControllerDelegate, verifier: QRClientVerifier, cancelButtonTitle: String) {
        self.init(delegate: delegate,
                  verifier: verifier,
                  cancelButtonTitle: cancelButtonTitle,
                  viewModel: QRScannerViewModel(verifier: verifier))
    }
}
