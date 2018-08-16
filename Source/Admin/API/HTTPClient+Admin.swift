//
//  HTTPClient+Admin.swift
//  OmiseGO
//
//  Created by Mederic Petit on 8/8/18.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

extension HTTPClient {
    /// Initialize an http client using a configuration object that can be used to query admin endpoints
    ///
    /// - Parameter config: The ClientConfiguration object
    public convenience init(config: AdminConfiguration) {
        self.init()
        self.config = config
    }
}
