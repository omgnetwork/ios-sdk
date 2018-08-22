//
//  HTTPAdminAPI.swift
//  OmiseGO
//
//  Created by Mederic Petit on 8/8/18.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

public class HTTPAdminAPI: HTTPAPI {
    /// Initialize an http client using a configuration object that can be used to query admin endpoints
    ///
    /// - Parameter config: The ClientConfiguration object
    public convenience init(config: AdminConfiguration) {
        self.init(config: config)
    }
}
