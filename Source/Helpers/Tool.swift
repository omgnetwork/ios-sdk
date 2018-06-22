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
