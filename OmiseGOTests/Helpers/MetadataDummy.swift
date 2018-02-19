//
//  MetadataDummy.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 13/2/2561 BE.
//  Copyright © 2561 OmiseGO. All rights reserved.
//

import UIKit
@testable import OmiseGO

struct MetadataDummy: Decodable, Parametrable {

    let metadata: [String: Any]?

    private enum CodingKeys: String, CodingKey {
        case metadata
    }

    init(metadata: [String: Any]?) {
        self.metadata = metadata
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {metadata = try container.decode([String: Any].self, forKey: .metadata)} catch {metadata = [:]}
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(metadata ?? [:], forKey: .metadata)
    }

    func encodedPayload() -> Data? {
        return try? JSONEncoder().encode(self)
    }
}
