//
//  APIAdminEndpointTest.swift
//  Tests
//
//  Created by Mederic Petit on 14/9/2018.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

@testable import OmiseGO
import XCTest

class APIAdminEndpointTest: XCTestCase {
    let validLoginParams = LoginParams(email: "email@example.com", password: "password")

    func testPath() {
        XCTAssertEqual(APIAdminEndpoint.login(params: self.validLoginParams).path, "/admin.login")
    }

    func testTask() {
        switch APIClientEndpoint.login(params: self.validLoginParams).task {
        case .requestParameters: break
        default: XCTFail("Wrong task")
        }
    }
}
