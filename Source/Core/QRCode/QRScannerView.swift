//
//  QRScannerView.swift
//  OmiseGO
//
//  Created by Mederic Petit on 9/2/2018.
//  Copyright © 2017-2019 Omise Go Pte. Ltd. All rights reserved.
//

import UIKit

class QRScannerView: UIView {
    lazy var overlayView: UIView = {
        let overlayView = QRScannerOverlayView()
        overlayView.backgroundColor = .clear
        overlayView.clipsToBounds = true
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        return overlayView
    }()

    let cameraView: UIView = {
        let cameraView = UIView()
        cameraView.clipsToBounds = true
        cameraView.translatesAutoresizingMaskIntoConstraints = false
        return cameraView
    }()

    lazy var cancelButton: UIButton = {
        let cancelButton = UIButton()
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        return cancelButton
    }()

    var readerPreviewLayer: CALayer!

    init(frame: CGRect, readerPreviewLayer: CALayer) {
        super.init(frame: frame)
        self.readerPreviewLayer = readerPreviewLayer
        self.setup()
    }

    required init?(coder _: NSCoder) {
        omiseGOWarn("init(coder:) shouldn't be called direcly, please use the designed init(frame:readerPreviewLayer:) instead")
        return nil
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        self.readerPreviewLayer.frame = self.bounds
    }

    // swiftlint:disable:next function_body_length
    func setup() {
        self.addSubview(self.cameraView)
        self.addSubview(self.overlayView)
        self.addSubview(self.cancelButton)
        self.cameraView.layer.addSublayer(self.readerPreviewLayer)

        self.addConstraint(NSLayoutConstraint(item: self.cancelButton,
                                              attribute: .height,
                                              relatedBy: .equal,
                                              toItem: nil,
                                              attribute: .notAnAttribute,
                                              multiplier: 1,
                                              constant: 50))
        self.addConstraint(NSLayoutConstraint(item: self.cancelButton,
                                              attribute: .bottom,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .bottom,
                                              multiplier: 1,
                                              constant: -16))
        [.leading, .trailing].forEach { attribute in
            self.addConstraint(NSLayoutConstraint(item: self.cancelButton,
                                                  attribute: attribute,
                                                  relatedBy: .equal,
                                                  toItem: self,
                                                  attribute: attribute,
                                                  multiplier: 1,
                                                  constant: 0))
        }
        [.left, .top, .right, .bottom].forEach { attribute in
            self.addConstraint(NSLayoutConstraint(item: self.cameraView,
                                                  attribute: attribute,
                                                  relatedBy: .equal,
                                                  toItem: self,
                                                  attribute: attribute,
                                                  multiplier: 1,
                                                  constant: 0))
        }
        [.left, .top, .right, .bottom].forEach { attribute in
            self.addConstraint(NSLayoutConstraint(item: self.overlayView,
                                                  attribute: attribute,
                                                  relatedBy: .equal,
                                                  toItem: self.cameraView,
                                                  attribute: attribute,
                                                  multiplier: 1,
                                                  constant: 0))
        }
    }
}
