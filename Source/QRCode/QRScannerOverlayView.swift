//
//  QRScannerOverlayView.swift
//  OmiseGO
//
//  Created by Mederic Petit on 9/2/2561 BE.
//  Copyright © 2561 OmiseGO. All rights reserved.
//

import UIKit

class QRScannerOverlayView: UIView {

    private lazy var outlineLayer: CAShapeLayer = {
        let outlineLayer = CAShapeLayer()
        outlineLayer.backgroundColor = UIColor.clear.cgColor
        outlineLayer.fillColor = UIColor.clear.cgColor
        outlineLayer.strokeColor = UIColor.white.cgColor
        outlineLayer.lineWidth = 2
        outlineLayer.lineDashPattern = [5.0, 4.0]
        outlineLayer.lineDashPhase = 0
        return outlineLayer
    }()

    private lazy var maskLayer: CAShapeLayer = {
        let maskLayer = CAShapeLayer()
        maskLayer.fillRule = kCAFillRuleEvenOdd
        maskLayer.fillColor = UIColor.black.cgColor
        maskLayer.opacity = 0.6
        return maskLayer
    }()

    override func draw(_ rect: CGRect) {
        var innerRect = rect.insetBy(dx: 50, dy: 50)
        let minSize = min(innerRect.width, innerRect.height)

        if innerRect.width != minSize {
            innerRect.origin.x += (innerRect.width - minSize) / 2
            innerRect.size.width = minSize
        } else if innerRect.height != minSize {
            innerRect.origin.y += (innerRect.height - minSize) / 2
            innerRect.size.height = minSize
        }
        let innerPath = UIBezierPath(roundedRect: innerRect, cornerRadius: 3)
        let outerPath = UIBezierPath(rect: rect)
        outerPath.usesEvenOddFillRule = true
        outerPath.append(innerPath)

        self.outlineLayer.path = innerPath.cgPath
        self.maskLayer.path = outerPath.cgPath

        self.layer.addSublayer(self.outlineLayer)
        self.layer.addSublayer(self.maskLayer)
    }

}
