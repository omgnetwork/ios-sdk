//
//  TestWebSocketDelegate.swift
//  Tests
//
//  Created by Mederic Petit on 23/3/18.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

import Starscream
import XCTest

class TestWebSocketDelegate: WebSocketDelegate {
    var didConnect: Bool = false
    var didDisconnect: Bool = false
    var didReceiveText: String?
    var didReceiveData: Data?
    var didSendData: Data?

    let expectation: XCTestExpectation?

    init(expectation: XCTestExpectation? = nil) {
        self.expectation = expectation
    }

    func websocketDidConnect(socket _: WebSocketClient) {
        self.didConnect = true
    }

    func websocketDidDisconnect(socket _: WebSocketClient, error _: Error?) {
        self.didDisconnect = true
    }

    func websocketDidReceiveMessage(socket _: WebSocketClient, text: String) {
        self.didReceiveText = text
        self.expectation?.fulfill()
    }

    func websocketDidReceiveData(socket _: WebSocketClient, data: Data) {
        self.didReceiveData = data
        self.expectation?.fulfill()
    }

    func websocketDidSendData(socket _: WebSocketClient, data: Data) {
        self.didSendData = data
        self.expectation?.fulfill()
    }
}
