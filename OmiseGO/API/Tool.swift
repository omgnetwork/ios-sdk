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

func deserializeData<ObjectType: Codable>(_ data: Data) throws -> ObjectType {
    let jsonDecoder = JSONDecoder()
    jsonDecoder.dateDecodingStrategy = .iso8601
    return try jsonDecoder.decode(ObjectType.self, from: data)
}
