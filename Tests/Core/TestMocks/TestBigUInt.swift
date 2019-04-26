//
//  TestBigUInt.swift
//  Tests
//
//  Created by Mederic Petit on 18/6/18.
//  Copyright © 2017-2019 Omise Go Pte. Ltd. All rights reserved.
//

import BigInt
@testable import OmiseGO

struct TestBigUInt {
    let value: BigInt
}

extension TestBigUInt: Codable {
    private enum CodingKeys: String, CodingKey {
        case value
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(value, forKey: .value)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        value = try container.decode(BigInt.self, forKey: .value)
    }
}
