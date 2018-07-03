//
//  Codable.swift
//  OmiseGO
//
//  Created by Mederic Petit on 18/6/18.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

import BigInt

let maxDecimalDigits = 38

private struct JSONCodingKeys: CodingKey {
    var stringValue: String

    init?(stringValue: String) {
        self.init(key: stringValue)
    }

    init(key: String) {
        self.stringValue = key
    }

    var intValue: Int?

    init?(intValue: Int) {
        self.init(stringValue: "\(intValue)")
        self.intValue = intValue
    }
}

extension KeyedDecodingContainerProtocol {
    func decode(_ type: BigInt.Type, forKey key: Key) throws -> BigInt {
        guard let bigInt = try self.decodeOptional(type, forKey: key) else {
            throw DecodingError.dataCorruptedError(forKey: key, in: self, debugDescription: "Invalid number")
        }
        return bigInt
    }

    func decode(_ type: BigInt.Type, forKey key: Key) throws -> BigInt? {
        return try self.decodeOptional(type, forKey: key)
    }

    func decodeIfPresent(_ type: BigInt.Type, forKey key: Key) throws -> BigInt? {
        guard contains(key) else {
            return nil
        }
        return try self.decode(type, forKey: key)
    }

    private func decodeOptional(_: BigInt.Type, forKey key: Key) throws -> BigInt? {
        let parsedBigInt: BigInt?
        // There is an issue currently in swift when initializing a Decimal number with an Int64 type.
        // https://bugs.swift.org/browse/SR-7054
        // This is a workaround where we first try to decode the number as a UInt and fallback to Decimal if it fails.
        do {
            parsedBigInt = BigInt(String((try self.decode(UInt.self, forKey: key))))
        } catch _ {
            do {
                parsedBigInt = BigInt((try self.decode(Decimal.self, forKey: key)).description)
            } catch _ {
                return nil
            }
        }
        guard let amount = parsedBigInt, amount.description.count <= maxDecimalDigits else {
            throw DecodingError.dataCorruptedError(forKey: key, in: self, debugDescription: "Invalid number")
        }
        return amount
    }

    func decode(_: [String: Any].Type, forKey key: Key) throws -> [String: Any] {
        let container = try self.nestedContainer(keyedBy: JSONCodingKeys.self, forKey: key)
        return try container.decodeJSONDictionary()
    }

    func decodeIfPresent(_ type: [String: Any].Type, forKey key: Key) throws -> [String: Any]? {
        guard contains(key) else {
            return nil
        }
        return try self.decode(type, forKey: key)
    }

    func decode(_: [Any].Type, forKey key: Key) throws -> [Any] {
        var container = try self.nestedUnkeyedContainer(forKey: key)
        return try container.decodeJSONArray()
    }

    func decodeIfPresent(_ type: [Any].Type, forKey key: Key) throws -> [Any]? {
        guard contains(key) else {
            return nil
        }
        return try self.decode(type, forKey: key)
    }

    fileprivate func decodeJSONDictionary() throws -> [String: Any] {
        var dictionary: [String: Any] = [:]

        for key in allKeys {
            if let boolValue = try? decode(Bool.self, forKey: key) {
                dictionary[key.stringValue] = boolValue
            } else if let intValue = try? decode(Int.self, forKey: key) {
                dictionary[key.stringValue] = intValue
            } else if let stringValue = try? decode(String.self, forKey: key) {
                dictionary[key.stringValue] = stringValue
            } else if let doubleValue = try? decode(Double.self, forKey: key) {
                dictionary[key.stringValue] = doubleValue
            } else if let nestedDictionary = try? decode([String: Any].self, forKey: key) {
                dictionary[key.stringValue] = nestedDictionary
            } else if let nestedArray = try? decode([Any].self, forKey: key) {
                dictionary[key.stringValue] = nestedArray
            } else if try decodeNil(forKey: key) {
                dictionary[key.stringValue] = nil
            }
        }
        return dictionary
    }
}

extension UnkeyedDecodingContainer {
    mutating func decodeJSONArray() throws -> [Any] {
        var array: [Any] = []
        while isAtEnd == false {
            if let value = try? decode(Bool.self) {
                array.append(value)
            } else if let value = try? decode(Int.self) {
                array.append(value)
            } else if let value = try? decode(Double.self) {
                array.append(value)
            } else if let value = try? decode(String.self) {
                array.append(value)
            } else if let nestedDictionary = try? decode([String: Any].self) {
                array.append(nestedDictionary)
            } else if let nestedArray = try? decode([Any].self) {
                array.append(nestedArray)
            }
        }
        return array
    }

    mutating func decode(_: [Any].Type) throws -> [Any] {
        var nestedContainer = try self.nestedUnkeyedContainer()
        return try nestedContainer.decodeJSONArray()
    }

    mutating func decode(_: [String: Any].Type) throws -> [String: Any] {
        let nestedContainer = try self.nestedContainer(keyedBy: JSONCodingKeys.self)
        return try nestedContainer.decodeJSONDictionary()
    }
}

extension KeyedEncodingContainerProtocol where Key == JSONCodingKeys {
    mutating func encode(_ value: [String: Any]) throws {
        try value.forEach({ key, value in
            let key = JSONCodingKeys(key: key)
            switch value {
            case let value as Bool:
                try encode(value, forKey: key)
            case let value as Int:
                try encode(value, forKey: key)
            case let value as String:
                try encode(value, forKey: key)
            case let value as Double:
                try encode(value, forKey: key)
            case let value as [String: Any]:
                try encode(value, forKey: key)
            case let value as [Any]:
                try encode(value, forKey: key)
            // swiftlint:disable:next syntactic_sugar
            case Optional<Any>.none:
                try encodeNil(forKey: key)
            default:
                throw EncodingError.invalidValue(value,
                                                 EncodingError.Context(codingPath: codingPath + [key],
                                                                       debugDescription: "Invalid JSON value"))
            }
        })
    }
}

extension KeyedEncodingContainerProtocol {
    mutating func encode(_ value: [String: Any], forKey key: Key) throws {
        var container = self.nestedContainer(keyedBy: JSONCodingKeys.self, forKey: key)
        try container.encode(value)
    }

    mutating func encodeIfPresent(_ value: [String: Any]?, forKey key: Key) throws {
        if let value = value {
            try self.encode(value, forKey: key)
        }
    }

    mutating func encode(_ value: [Any], forKey key: Key) throws {
        var container = self.nestedUnkeyedContainer(forKey: key)
        try container.encode(value)
    }

    mutating func encodeIfPresent(_ value: [Any]?, forKey key: Key) throws {
        if let value = value {
            try self.encode(value, forKey: key)
        }
    }

    mutating func encode(_ value: BigInt, forKey key: Key) throws {
        guard value.description.count <= maxDecimalDigits else {
            let errorDescription = "Value is exceeding the maximum encodable number"
            throw EncodingError.invalidValue(value, .init(codingPath: self.codingPath,
                                                          debugDescription: errorDescription))
        }
        guard let decimalValue = Decimal(string: value.description) else {
            let errorDescription = "Value is not a number"
            throw EncodingError.invalidValue(value, .init(codingPath: self.codingPath,
                                                          debugDescription: errorDescription))
        }
        try self.encode(decimalValue, forKey: key)
    }

    mutating func encodeIfPresent(_ value: BigInt?, forKey key: Key) throws {
        if let value = value {
            try self.encode(value, forKey: key)
        }
    }

    mutating func encode(_ value: BigInt?, forKey key: Key) throws {
        if let value = value {
            try self.encode(value, forKey: key)
        } else {
            try self.encodeNil(forKey: key)
        }
    }
}

extension UnkeyedEncodingContainer {
    mutating func encode(_ value: [Any]) throws {
        try value.enumerated().forEach({ index, value in
            switch value {
            case let value as Bool:
                try encode(value)
            case let value as Int:
                try encode(value)
            case let value as String:
                try encode(value)
            case let value as Double:
                try encode(value)
            case let value as [String: Any]:
                try encodeJSONDictionary(value)
            case let value as [Any]:
                try encodeJSONArray(value)
            // swiftlint:disable:next syntactic_sugar
            case Optional<Any>.none:
                try encodeNil()
            default:
                let keys = JSONCodingKeys(intValue: index).map({ [$0] }) ?? []
                throw EncodingError.invalidValue(value,
                                                 EncodingError.Context(codingPath: codingPath + keys,
                                                                       debugDescription: "Invalid JSON value"))
            }
        })
    }

    mutating func encodeJSONDictionary(_ value: [String: Any]) throws {
        var nestedContainer = self.nestedContainer(keyedBy: JSONCodingKeys.self)
        try nestedContainer.encode(value)
    }

    private mutating func encodeJSONArray(_ value: [Any]) throws {
        var nestedContainer = self.nestedUnkeyedContainer()
        try nestedContainer.encode(value)
    }
}
