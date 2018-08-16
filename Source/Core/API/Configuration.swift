//
//  Configuration.swift
//  OmiseGO
//
//  Created by Mederic Petit on 9/10/2017.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

/// Protocol containing the required variable for the initialization of a Client
protocol Configuration {
    /// The current SDK version
    var apiVersion: String { get }
    /// The base URL of the wallet server:
    /// When initializing the HTTPClient, this needs to be an http(s) url
    /// When initializing the SocketClient, this needs to be a ws(s) url
    var baseURL: String { get }
    /// The credential object containing the authentication info if needed
    var credentials: Credential { get set }
    /// A boolean indicating if the debug logs should be printed to the console
    var debugLog: Bool { get }
}
