//
//  DummyWebSocketDelegate.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 23/3/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import Starscream
import XCTest

class DummyWebSocketDelegate: WebSocketDelegate {

    var didConnect: Bool = false
    var didDisconnect: Bool = false
    var didReceiveText: String?
    var didReceiveData: Data?
    var didSendData: Data?

    let expectation: XCTestExpectation?

    init(expectation: XCTestExpectation? = nil) {
        self.expectation = expectation
    }

    func websocketDidConnect(socket: WebSocketClient) {
        self.didConnect = true
    }

    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        self.didDisconnect = true
    }

    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        self.didReceiveText = text
        self.expectation?.fulfill()

    }

    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        self.didReceiveData = data
        self.expectation?.fulfill()
    }

    func websocketDidSendData(socket: WebSocketClient, data: Data) {
        self.didSendData = data
        self.expectation?.fulfill()
    }

}
