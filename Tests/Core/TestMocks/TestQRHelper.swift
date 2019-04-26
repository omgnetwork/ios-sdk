//
//  TestQRHelper.swift
//  Tests
//
//  Created by Mederic Petit on 7/2/2018.
//  Copyright © 2017-2019 Omise Go Pte. Ltd. All rights reserved.
//

import UIKit

struct TestQRHelper {
    static func readQRCode(fromImage image: UIImage) -> String {
        let detector: CIDetector = CIDetector(ofType: CIDetectorTypeQRCode,
                                              context: nil,
                                              options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])!
        let features = detector.features(in: CIImage(image: image)!)
        var result: String = ""
        for feature in features as! [CIQRCodeFeature] {
            result += feature.messageString ?? ""
        }
        return result
    }
}
