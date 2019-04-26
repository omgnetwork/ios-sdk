//
//  TestAPIEndpoint.swift
//  Tests
//
//  Created by Mederic Petit on 9/8/18.
//  Copyright © 2017-2019 Omise Go Pte. Ltd. All rights reserved.
//

@testable import OmiseGO

struct TestAPIEndpoint: APIEndpoint {
    let path: String
    let task: HTTPTask

    init(path: String = "/test", task: HTTPTask = .requestPlain) {
        self.path = path
        self.task = task
    }
}
