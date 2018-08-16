//
//  QRClientVerifier.swift
//  OmiseGO
//
//  Created by Mederic Petit on 7/8/18.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

public struct QRClientVerifier: QRVerifier {
    let client: HTTPClient

    public init(client: HTTPClient) {
        self.client = client
    }

    public func onData(data: String, callback: @escaping (Response<TransactionRequest>) -> Void) {
        TransactionRequest.get(using: self.client, formattedId: data, callback: callback)
    }
}
