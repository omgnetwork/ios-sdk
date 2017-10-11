//
//  URLEncoderTest.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 10/10/2560 BE.
//  Copyright © 2560 OmiseGO. All rights reserved.
//

import Foundation
@testable import OmiseGO
import XCTest

extension AnyJSONType: Encodable {
    public func encode(to encoder: Encoder) throws {
        switch jsonValue {
        case Optional<Any>.none:
            var container = encoder.singleValueContainer()
            try container.encodeNil()
        case let value as Int:
            var container = encoder.singleValueContainer()
            try container.encode(value)
        case let value as Bool:
            var container = encoder.singleValueContainer()
            try container.encode(value)
        case let value as Double:
            var container = encoder.singleValueContainer()
            try container.encode(value)
        case let value as String:
            var container = encoder.singleValueContainer()
            try container.encode(value)
        case let value as Date:
            var container = encoder.singleValueContainer()
            let formatter = ISO8601DateFormatter()
            try container.encode(formatter.string(from: value))
        case let value as [Encodable]:
            var container = encoder.unkeyedContainer()
            try container.encode(contentsOf: value.map(AnyJSONType.init))
        case let value as [String: Encodable]:
            var container = encoder.container(keyedBy: AnyJSONAttributeEncodingKey.self)
            let sortedValuesByKey = value.sorted(by: { (first, second) -> Bool in
                return first.key < second.key
            })
            for (key, value) in sortedValuesByKey {
                let value = AnyJSONType(value)
                try container.encode(value, forKey: AnyJSONAttributeEncodingKey(stringValue: key))
            }
        default: fatalError()
        }
    }
}

private struct AnyJSONAttributeEncodingKey: CodingKey {
    let stringValue: String
    init?(intValue: Int) { return nil }
    var intValue: Int? { return nil }
    init(stringValue: String) { self.stringValue = stringValue }
}

class URLEncoderTest: OmiseGOTestCase {
    func testEncodeBasic() throws {
        let values = AnyJSONType(["hello": "world"])
        let encoder = URLQueryItemEncoder()
        let result = try encoder.encode(values)

        XCTAssertEqual(1, result.count)
        XCTAssertEqual("hello", result[0].name)
        XCTAssertEqual("world", result[0].value)
    }

    func testEncodeMultipleTypes() throws {
        let values = AnyJSONType([
            "0hello": "world",
            "1num": 42,
            "2number": 64,
            "3long": 1234123412341234,
            "4bool": false,
            "5boolean": true,
            "6date": Date(timeIntervalSince1970: 0),
            "7nil": String?.none as String?
            ] as [String: Any?])

        let encoder = URLQueryItemEncoder()
        let result = try encoder.encode(values).map({ (query) in query.value ?? "$*nil*$" })
        XCTAssertEqual(8, result.count)
        XCTAssertEqual(result, [
            "world",
            "42",
            "64",
            "1234123412341234",
            "false",
            "true",
            "1970-01-01T00:00:00Z",
            "$*nil*$"
            ])
    }

}
