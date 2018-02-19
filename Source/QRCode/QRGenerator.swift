//
//  QRCode.swift
//  OmiseGO
//
//  Created by Mederic Petit on 6/2/2561 BE.
//  Copyright © 2561 OmiseGO. All rights reserved.
//

import UIKit

struct QRCode {

    static func generateQRCode(fromData data: Data, outputSize: CGSize) -> UIImage? {
        guard let qrFilter = CIFilter(name: "CIQRCodeGenerator") else { return nil }

        qrFilter.setDefaults()
        qrFilter.setValue(data, forKey: "inputMessage")

        guard let ciImage = qrFilter.outputImage else { return nil }

        let ciImageSize = ciImage.extent.size
        let wRatio = outputSize.width / ciImageSize.width
        let hRatio = outputSize.height / ciImageSize.height
        let transform = CGAffineTransform(scaleX: wRatio, y: hRatio)
        let scaledImage = ciImage.transformed(by: transform)
        let ciContext = CIContext()
        guard let cgImage = ciContext.createCGImage(scaledImage, from: scaledImage.extent) else { return nil }
        return UIImage(cgImage: cgImage)
    }
}
