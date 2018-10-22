//
//  QRScannerViewController.swift
//  OmiseGO
//
//  Created by Mederic Petit on 8/2/2018.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

import UIKit

/// The delegate that will receive events from the QRScannerViewController
public protocol QRScannerViewControllerDelegate: class {
    /// Called when the user tap on the cancel button.
    /// Note that the view controller is not automatically dismissed when the user tap on cancel.
    ///
    /// - Parameter scanner: The QR scanner view controller
    func scannerDidCancel(scanner: QRScannerViewController)
    /// Called when a QR code was successfuly decoded to a TransactionRequest object
    ///
    /// - Parameters:
    ///   - scanner: The QR scanner view controller
    ///   - transactionRequest: The transaction request decoded by the scanner
    func scannerDidDecode(scanner: QRScannerViewController, transactionRequest: TransactionRequest)
    /// Called when a QR code has been scanned but the scanner was not able to decode it as a TransactionRequest
    /// The QR code may be invalid or a network error occured
    ///
    /// - Parameters:
    ///   - scanner: The QR scanner view controller
    ///   - error: The error returned by the scanner
    func scannerDidFailToDecode(scanner: QRScannerViewController, withError error: OMGError)
}

/// The view controller managing the scanner
/// This scanner can be used to scan QRCode containing a formatted id from a transaction request
public class QRScannerViewController: UIViewController {
    weak var delegate: QRScannerViewControllerDelegate?
    var viewModel: QRScannerViewModelProtocol!
    lazy var loadingView: QRScannerLoadingView = {
        let loadingView = QRScannerLoadingView()
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        loadingView.isUserInteractionEnabled = false
        return loadingView
    }()

    init?(delegate: QRScannerViewControllerDelegate,
          verifier _: QRVerifier,
          cancelButtonTitle: String,
          viewModel: QRScannerViewModelProtocol) {
        guard viewModel.isQRCodeAvailable() else {
            omiseGOWarn("QR code reader is not available on this device")
            return nil
        }
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        self.configureViewModel()
        self.delegate = delegate
        self.setupUIWithCancelButtonTitle(cancelButtonTitle)
    }

    func configureViewModel() {
        self.viewModel.onLoadingStateChange = { isLoading in
            self.toggleLoadingOverlay(show: isLoading)
        }
        self.viewModel.onGetTransactionRequest = { transactionRequest in
            self.delegate?.scannerDidDecode(scanner: self, transactionRequest: transactionRequest)
        }
        self.viewModel.onError = { error in
            self.delegate?.scannerDidFailToDecode(scanner: self, withError: error)
        }
    }

    public required init?(coder _: NSCoder) {
        omiseGOWarn("init(coder:) shouldn't be called direcly, please use the designed init(delegate:client:) instead")
        return nil
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.startScanning()
    }

    public override func viewWillDisappear(_ animated: Bool) {
        self.viewModel.stopScanning()
        super.viewWillDisappear(animated)
    }

    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.viewModel.updateQRReaderPreviewLayer(withFrame: self.view.bounds)
    }

    func toggleLoadingOverlay(show: Bool) {
        show ? self.loadingView.showLoading() : self.loadingView.hideLoading()
    }

    private func setupUIWithCancelButtonTitle(_ cancelButtonTitle: String) {
        self.view.backgroundColor = .black
        let qrScannerView = QRScannerView(frame: self.view.frame,
                                          readerPreviewLayer: self.viewModel.readerPreviewLayer())
        qrScannerView.translatesAutoresizingMaskIntoConstraints = false
        qrScannerView.cancelButton.setTitle(cancelButtonTitle, for: .normal)
        qrScannerView.cancelButton.addTarget(self, action: #selector(self.didTapCancel), for: .touchUpInside)
        self.view.addSubview(qrScannerView)
        self.view.addSubview(self.loadingView)
        [NSLayoutConstraint.Attribute.left, .top, .right, .bottom].forEach({
            self.view.addConstraint(NSLayoutConstraint(item: qrScannerView,
                                                       attribute: $0,
                                                       relatedBy: .equal,
                                                       toItem: view,
                                                       attribute: $0,
                                                       multiplier: 1,
                                                       constant: 0))
            self.view.addConstraint(NSLayoutConstraint(item: self.loadingView,
                                                       attribute: $0,
                                                       relatedBy: .equal,
                                                       toItem: view,
                                                       attribute: $0,
                                                       multiplier: 1,
                                                       constant: 0))
        })
    }

    @objc func didTapCancel(_: UIButton) {
        self.delegate?.scannerDidCancel(scanner: self)
    }

    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}
