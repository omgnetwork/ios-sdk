//
//  AccountGetParams.swift
//  OmiseGO
//
//  Created by Mederic Petit on 26/9/18.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

/// Represents a structure used to retrieve an account from its id
public struct AccountGetParams: APIParameters {
    /// The id of the account to retrieve
    public let id: String

    /// Initialize the params used to retrive a account from its id
    ///
    /// - Parameters:
    ///   - id: The id of the account to retrieve
    public init(id: String) {
        self.id = id
    }
}
