//
//  QRScannerView.swift
//  OmiseGO
//
//  Created by Mederic Petit on 9/2/2018 BE.
//  Copyright © 2018 OmiseGO. All rights reserved.
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

    required init?(coder aDecoder: NSCoder) {
        //swiftlint:disable:next line_length
        omiseGOWarn("init(coder:) shouldn't be called direcly, please use the designed init(frame:readerPreviewLayer:) instead")
        return nil
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        self.readerPreviewLayer.frame = self.bounds
    }

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
        [.leading, .trailing, .bottom].forEach({ (attribute) in
            self.addConstraint(NSLayoutConstraint(item: self.cancelButton,
                                                  attribute: attribute,
                                                  relatedBy: .equal,
                                                  toItem: self,
                                                  attribute: attribute,
                                                  multiplier: 1,
                                                  constant: 0))
        })
        [.left, .top, .right, .bottom].forEach({ (attribute) in
            self.addConstraint(NSLayoutConstraint(item: self.cameraView,
                                                  attribute: attribute,
                                                  relatedBy: .equal,
                                                  toItem: self,
                                                  attribute: attribute,
                                                  multiplier: 1,
                                                  constant: 0))
        })
        [.left, .top, .right, .bottom].forEach({ (attribute) in
            self.addConstraint(NSLayoutConstraint(item: self.overlayView,
                                                  attribute: attribute,
                                                  relatedBy: .equal,
                                                  toItem: self.cameraView,
                                                  attribute: attribute,
                                                  multiplier: 1,
                                                  constant: 0))
        })
    }

}
