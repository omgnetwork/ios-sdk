//
//  TestDate.swift
//  Tests
//
//  Created by Mederic Petit on 23/2/18.
//  Copyright © 2017-2019 Omise Go Pte. Ltd. All rights reserved.
//

import UIKit

struct TestDate: Decodable {
    let date1: Date
    let date2: Date
    let date3: Date

    enum CodingKeys: String, CodingKey {
        case date1 = "date_1"
        case date2 = "date_2"
        case date3 = "date_3"
    }
}

struct TestDateInvalid: Decodable {
    let invalidDate: Date

    enum CodingKeys: String, CodingKey {
        case invalidDate = "invalid_date"
    }
}
