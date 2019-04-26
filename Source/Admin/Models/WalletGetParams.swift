//
//  WalletGetParams.swift
//  OmiseGO
//
//  Created by Mederic Petit on 17/9/18.
//  Copyright © 2017-2019 Omise Go Pte. Ltd. All rights reserved.
//

/// Represents a structure used to retrieve a wallet from its address
public struct WalletGetParams: APIParameters {
    /// The address of the wallet to retrieve
    public let address: String

    /// Initialize the params used to retrive a wallet from its address
    ///
    /// - Parameters:
    ///   - address: The address of the wallet to retrieve
    public init(address: String) {
        self.address = address
    }
}
