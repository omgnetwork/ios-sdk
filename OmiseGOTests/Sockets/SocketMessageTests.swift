//
//  SocketMessageTests.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 22/3/18.
//  Copyright © 2018 Omise Go Pte. Ltd. All rights reserved.
//

import XCTest
@testable import OmiseGO

class SocketMessageTests: XCTestCase {

    var socketMessage: SocketMessage!

    override func setUp() {
        super.setUp()
        let payload = SocketPayloadSend(topic: "a_topic", event: .join, ref: "1", data: [:])
        self.socketMessage = SocketMessage(socketPayload: payload)
    }

    func testCallsSuccessHandlerWhenSucceed() {
        let expectation = self.expectation(description: "Calls success handler when succeed")
        let payload = StubGenerator.socketPayloadReceive()
        let handler: ((GenericObjectEnum) -> Void) = { response in
            switch response {
            case .transactionConsumption(object: let tc): XCTAssertNotNil(tc)
            default: XCTFail("Unexpected response")
            }
            expectation.fulfill()
        }
        self.socketMessage.onSuccess(handler)
        self.socketMessage.handleResponse(withPayload: payload)
        self.waitForExpectations(timeout: 1, handler: nil)
    }

    func testCallsErrorHandlerWhenFail() {
        let expectation = self.expectation(description: "Calls success handler when succeed")
        let payload = StubGenerator.socketPayloadReceive(data: GenericObject(object: .error(error: .unexpected(message: "dummy error"))),
                                                         success: false)
        let handler: ((OmiseGOError) -> Void) = { error in
            XCTAssertEqual(error.message, "unexpected error: dummy error")
            expectation.fulfill()
        }
        self.socketMessage.onError(handler)
        self.socketMessage.handleResponse(withPayload: payload)
        self.waitForExpectations(timeout: 1, handler: nil)
    }

    func testTopicReturnsCorrectValue() {
        let payloadSend = SocketPayloadSend(topic: "topic_a", event: .join, ref: "1", data: [:])
        let socketMessageSend = SocketMessage(socketPayload: payloadSend)
        XCTAssertEqual(socketMessageSend.topic(), "topic_a")
        let payloadReceive = StubGenerator.socketPayloadReceive(topic: "topic_b")
        let socketMessageReceive = SocketMessage(socketPayload: payloadReceive)
        XCTAssertEqual(socketMessageReceive.topic(), "topic_b")
    }

}
