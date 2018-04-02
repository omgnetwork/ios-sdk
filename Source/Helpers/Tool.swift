//
//  Tool.swift
//  OmiseGO
//
//  Created by Mederic Petit on 9/10/2017.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

func omiseGOWarn(_ message: String) {
    print("[omiseGO] WARN: \(message)")
}

func omiseGOInfo(_ message: String) {
    print("[omiseGO] INFO: \(message)")
}

func deserializeData<ObjectType: Decodable>(_ data: Data) throws -> ObjectType {
    let jsonDecoder = JSONDecoder()
    jsonDecoder.dateDecodingStrategy = .custom({return try dateDecodingStrategy(decoder: $0)})
    return try jsonDecoder.decode(ObjectType.self, from: data)
}

func serialize<ObjectType: Encodable>(_ object: ObjectType) throws -> Data {
    let jsonEncoder = JSONEncoder()
    jsonEncoder.dateEncodingStrategy = .custom({return try dateEncodingStrategy(date: $0, encoder: $1)})
    return try jsonEncoder.encode(object)
}

func dateDecodingStrategy(decoder: Decoder) throws -> Date {
    let container = try decoder.singleValueContainer()
    let dateStr = try container.decode(String.self)
    return try dateStr.toDate()

}

func dateEncodingStrategy(date: Date, encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(date.toString(withFormat: "yyyy-MM-dd'T'HH:mm:ssZZZZZ", timeZone: TimeZone(secondsFromGMT: 0)))
}

extension String {

    func toDate() throws -> Date {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSZ"
        if let date = formatter.date(from: self) {
            return date
        }
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        if let date = formatter.date(from: self) {
            return date
        }
        throw OMGError.unexpected(message: "Invalid date format")
    }

}

extension Date {

    func toString(withFormat format: String? = "yyyy-MM-dd'T'HH:mm:ssZZZZZ",
                  timeZone: TimeZone? = TimeZone.current) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = timeZone!
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter.string(from: self)
    }

}

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
    func decode(_ type: [String: Any].Type, forKey key: Key) throws -> [String: Any] {
        let container = try self.nestedContainer(keyedBy: JSONCodingKeys.self, forKey: key)
        return try container.decodeJSONDictionary()
    }

    func decodeIfPresent(_ type: [String: Any].Type, forKey key: Key) throws -> [String: Any]? {
        guard contains(key) else {
            return nil
        }
        return try decode(type, forKey: key)
    }

    func decode(_ type: [Any].Type, forKey key: Key) throws -> [Any] {
        var container = try self.nestedUnkeyedContainer(forKey: key)
        return try container.decodeJSONArray()
    }

    func decodeIfPresent(_ type: [Any].Type, forKey key: Key) throws -> [Any]? {
        guard contains(key) else {
            return nil
        }
        return try decode(type, forKey: key)
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

    mutating func decode(_ type: [Any].Type) throws -> [Any] {
        var nestedContainer = try self.nestedUnkeyedContainer()
        return try nestedContainer.decodeJSONArray()
    }

    mutating func decode(_ type: [String: Any].Type) throws -> [String: Any] {
        let nestedContainer = try self.nestedContainer(keyedBy: JSONCodingKeys.self)
        return try nestedContainer.decodeJSONDictionary()
    }
}

extension KeyedEncodingContainerProtocol where Key == JSONCodingKeys {
    mutating func encode(_ value: [String: Any]) throws {
        try value.forEach({ (key, value) in
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
            //swiftlint:disable:next syntactic_sugar
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
            try encode(value, forKey: key)
        }
    }

    mutating func encode(_ value: [Any], forKey key: Key) throws {
        var container = self.nestedUnkeyedContainer(forKey: key)
        try container.encode(value)
    }

    mutating func encodeIfPresent(_ value: [Any]?, forKey key: Key) throws {
        if let value = value {
            try encode(value, forKey: key)
        }
    }
}

extension UnkeyedEncodingContainer {
    mutating func encode(_ value: [Any]) throws {
        try value.enumerated().forEach({ (index, value) in
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
            //swiftlint:disable:next syntactic_sugar
            case Optional<Any>.none:
                try encodeNil()
            default:
                let keys = JSONCodingKeys(intValue: index).map({[$0]}) ?? []
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
