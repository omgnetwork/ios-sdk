//
//  Tool.swift
//  OmiseGO
//
//  Created by Mederic Petit on 9/10/2560 BE.
//  Copyright © 2560 OmiseGO. All rights reserved.
//

import Foundation

func omiseGOWarn(_ message: String) {
    print("[omiseGO] WARN: \(message)")
}

func deserializeData<ObjectType: Decodable>(_ data: Data) throws -> ObjectType {
    let jsonDecoder = JSONDecoder()
    return try jsonDecoder.decode(ObjectType.self, from: data)
}

extension Date {

    func toString(withFormat format: String? = "yyyy-MM-dd'T'HH:mm:ssZZZZZ") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
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
                dictionary[key.stringValue] = true
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

    mutating func decode(_ type: [String: Any].Type) throws -> [String: Any] {
        let nestedContainer = try self.nestedContainer(keyedBy: JSONCodingKeys.self)
        return try nestedContainer.decodeJSONDictionary()
    }
}
