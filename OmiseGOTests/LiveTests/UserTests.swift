//
//  UserTests.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 18/10/2560 BE.
//  Copyright © 2560 OmiseGO. All rights reserved.
//

import Foundation
import XCTest
@testable import OmiseGO

class UserTests: LiveTest {

//    func testCurrentUserRetrieve() {
//        let expectation = self.expectation(description: "User result")
//        let request = User.getCurrent { (result) in
//            defer { expectation.fulfill() }
//            switch result {
//            case .success(let user):
//                XCTAssertEqual(user.id, "06ba7634-109e-42e6-8f40-52fc5bc08a9c")
//                XCTAssertEqual(user.providerUserId, "1234")
//                XCTAssertEqual(user.username, "john.doe@example.com")
//                XCTAssertEqual(user.metadata["first_name"]?.jsonValue as? String, "John")
//                XCTAssertEqual(user.metadata["last_name"]?.jsonValue as? String, "Doe")
//            case .fail(let error):
//                XCTFail("\(error)")
//            }
//        }
//        XCTAssertNotNil(request)
//        waitForExpectations(timeout: 15.0, handler: nil)
//    }

}
