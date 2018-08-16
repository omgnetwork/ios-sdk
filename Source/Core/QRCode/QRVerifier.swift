//
//  QRVerifier.swift
//  OmiseGO
//
//  Created by Mederic Petit on 7/8/18.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

/// Takes care of fetching objects decoded by the QR code scanner.
public protocol QRVerifier {
    func onData(data: String, callback: @escaping Request<TransactionRequest>.Callback)
}
