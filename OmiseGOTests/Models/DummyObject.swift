//
//  DummyObject.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 11/10/2560 BE.
//  Copyright © 2560 OmiseGO. All rights reserved.
//

import UIKit
@testable import OmiseGO

struct DummyTestObject: Parametrable, Decodable {

    func encodedPayload() -> Data? {
        return try? JSONEncoder().encode(self)
    }

    var object: String = ""

}
