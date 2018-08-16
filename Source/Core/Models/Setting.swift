//
//  Setting.swift
//  OmiseGO
//
//  Created by Mederic Petit on 12/10/2017.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

/// Represents the global settings of the eWallet
public struct Setting: Decodable {
    /// An array of tokens available
    public let tokens: [Token]
}
