//
//  DummyObject.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 11/10/2017.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

import UIKit
@testable import OmiseGO

struct DummyTestObject: Parametrable, Decodable {

    func encodedPayload() -> Data? {
        return try? JSONEncoder().encode(self)
    }

    var object: String = ""

}
