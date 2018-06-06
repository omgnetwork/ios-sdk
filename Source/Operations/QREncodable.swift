//
//  QREncodable.swift
//  OmiseGO
//
//  Created by Mederic Petit on 5/6/18.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

/// A protocol that takes care of the encoding and generating QR images of different structs
public protocol QREncodable {
    func qrImage(withSize size: CGSize) -> UIImage?
}

public extension QREncodable where Self == TransactionRequest {

    /// Generates a QR image containing the encoded transaction request formattedId
    ///
    /// - Parameter size: the desired image size
    /// - Returns: A QR image if the transaction request was successfuly encoded, nil otherwise.
    public func qrImage(withSize size: CGSize = CGSize(width: 200, height: 200)) -> UIImage? {
        guard let data = self.formattedId.data(using: .isoLatin1) else { return nil }
        return QRGenerator.generateQRCode(fromData: data, outputSize: size)
    }

}
