//
//  SocketPayload.swift
//  OmiseGO
//
//  Created by Mederic Petit on 12/3/18.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

struct SocketPayloadSend {

    let topic: String
    let event: SocketEventSend
    let ref: String
    let data: [String: Any]

    init(topic: String, event: SocketEventSend, ref: String, data: [String: Any] = [:]) {
        self.topic = topic
        self.event = event
        self.ref = ref
        self.data = data
    }

}

extension SocketPayloadSend: Parametrable {

    private enum CodingKeys: String, CodingKey {
        case topic
        case event
        case data
        case ref
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(topic, forKey: .topic)
        try container.encode(event, forKey: .event)
        try container.encode(data, forKey: .data)
        try container.encode(ref, forKey: .ref)
    }

}

struct SocketPayloadReceive: Decodable {

    let topic: String
    let event: SocketEvent
    let ref: String?
    let data: GenericObject
    let version: String
    let success: Bool

}
