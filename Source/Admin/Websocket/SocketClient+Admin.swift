//
//  SocketClient+Admin.swift
//  OmiseGO
//
//  Created by Mederic Petit on 10/10/18.
//  Copyright © 2017-2019 Omise Go Pte. Ltd. All rights reserved.
//

extension SocketClient {
    /// Initialize a websocket client using a configuration object
    ///
    /// - Parameters:
    ///   - config: The configuration object containing the client configuration
    ///   - delegate: The delegate that should receive connection events
    /// - Note: the baseURL of the Configuration needs to be a socket url (wss://your.domain.com)
    public convenience init(config: AdminConfiguration, delegate: SocketConnectionDelegate?) {
        self.init()
        self.config = config
        self.delegate = delegate
        self.initWebSocket()
    }

    /// Invalidate the current (if any) socket connection and prepare the client for a new one with the updated configuration.
    /// Note that the active connection will be droped and any topic currently subscribed will be unsubscribed.
    /// You will need to start listening for events again.
    ///
    /// - Parameter configuration: The updated Configuration
    public func updateConfiguration(_ configuration: AdminConfiguration) {
        self.config = configuration
        self.cleanup()
        self.initWebSocket()
    }
}
