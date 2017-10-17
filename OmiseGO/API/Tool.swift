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
