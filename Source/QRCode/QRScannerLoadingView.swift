//
//  QRScannerLoadingView.swift
//  OmiseGO
//
//  Created by Mederic Petit on 12/2/2018 BE.
//  Copyright © 2018 OmiseGO. All rights reserved.
//

import UIKit

class QRScannerLoadingView: UIView {

    lazy var loadingSpinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
        spinner.hidesWhenStopped = true
        spinner.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(spinner)
        [NSLayoutAttribute.centerX, NSLayoutAttribute.centerY].forEach({ (attribute) in
            self.addConstraint(NSLayoutConstraint(item: spinner,
                                                  attribute: attribute,
                                                  relatedBy: .equal,
                                                  toItem: self,
                                                  attribute: attribute,
                                                  multiplier: 1,
                                                  constant: 0))
        })
        return spinner
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = .clear
    }

    func showLoading() {
        self.loadingSpinner.startAnimating()
    }

    func hideLoading() {
        self.loadingSpinner.stopAnimating()
    }

}
