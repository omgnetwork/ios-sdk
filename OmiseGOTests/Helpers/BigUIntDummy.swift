//
//  BigIntDummy.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 18/6/18.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

@testable import OmiseGO
import BigInt

struct BigIntDummy {
    let value: BigInt
}

extension BigIntDummy: Codable {
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
