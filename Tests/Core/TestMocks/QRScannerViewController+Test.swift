//
//  QRScannerViewController+Test.swift
//  Tests
//
//  Created by Mederic Petit on 9/8/18.
//  Copyright © 2017-2019 Omise Go Pte. Ltd. All rights reserved.
//

@testable import OmiseGO

extension QRScannerViewController {
    convenience init?(delegate: QRScannerViewControllerDelegate, verifier: TestQRVerifier, cancelButtonTitle: String) {
        self.init(delegate: delegate,
                  verifier: verifier,
                  cancelButtonTitle: cancelButtonTitle,
                  viewModel: QRScannerViewModel(verifier: verifier))
    }
}
