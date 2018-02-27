//
//  QRScannerViewController.swift
//  OmiseGO
//
//  Created by Mederic Petit on 8/2/2018 BE.
//  Copyright © 2018 OmiseGO. All rights reserved.
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
    func scannerDidFailToDecode(scanner: QRScannerViewController, withError error: OmiseGOError)
}

/// The view controller managing the scanner
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
          client: OMGClient,
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

    /// Initialize the QR code scanner. You should always use this method to initialize it.
    ///
    /// - Parameters:
    ///   - delegate: The delegate that will receive the events from the scanner
    ///   - client: An API client.
    ///             This client need to be initialized with a OMGConfiguration struct before being used.
    ///   - cancelButtonTitle: The title of the cancel button
    /// - Returns: An optional cancellable request.
    public convenience init?(delegate: QRScannerViewControllerDelegate, client: OMGClient, cancelButtonTitle: String) {
        self.init(delegate: delegate,
                  client: client,
                  cancelButtonTitle: cancelButtonTitle,
                  viewModel: QRScannerViewModel(client: client))
    }

    func configureViewModel() {
        self.viewModel.onLoadingStateChange = { (isLoading) in
            self.toggleLoadingOverlay(show: isLoading)
        }
        self.viewModel.onGetTransactionRequest = { (transactionRequest) in
            self.delegate?.scannerDidDecode(scanner: self, transactionRequest: transactionRequest)
        }
        self.viewModel.onError = { (error) in
            self.delegate?.scannerDidFailToDecode(scanner: self, withError: error)
        }
    }

    public required init?(coder aDecoder: NSCoder) {
        omiseGOWarn("init(coder:) shouldn't be called direcly, please use the designed init(delegate:client:) instead")
        return nil
    }

    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.startScanning()
    }

    override public func viewWillDisappear(_ animated: Bool) {
        self.viewModel.stopScanning()
        super.viewWillDisappear(animated)
    }

    override public func viewWillLayoutSubviews() {
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
        qrScannerView.cancelButton.addTarget(self, action: #selector(didTapCancel), for: .touchUpInside)
        self.view.addSubview(qrScannerView)
        self.view.addSubview(self.loadingView)
        [NSLayoutAttribute.left, .top, .right, .bottom].forEach({ (attribute) in
            self.view.addConstraint(NSLayoutConstraint(item: qrScannerView,
                                                       attribute: attribute,
                                                       relatedBy: .equal,
                                                       toItem: view,
                                                       attribute: attribute,
                                                       multiplier: 1,
                                                       constant: 0))
            self.view.addConstraint(NSLayoutConstraint(item: self.loadingView,
                                                       attribute: attribute,
                                                       relatedBy: .equal,
                                                       toItem: view,
                                                       attribute: attribute,
                                                       multiplier: 1,
                                                       constant: 0))
        })

    }

    @objc func didTapCancel(_ button: UIButton) {
        self.delegate?.scannerDidCancel(scanner: self)
    }

    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

}
