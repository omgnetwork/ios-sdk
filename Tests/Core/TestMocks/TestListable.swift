//
//  TestListable.swift
//  Tests
//
//  Created by Mederic Petit on 7/3/18.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

@testable import OmiseGO

struct TestListable: Decodable, Listable {
    static func list(using client: HTTPClient,
                     callback: @escaping ListRequestCallback) {
        let endpoint = TestAPIEndpoint(path: "dummy.listable.failure")
        self.list(using: client, endpoint: endpoint, callback: callback)
    }
}

struct PaginatedTestListable: Decodable, PaginatedListable {
    static func list(using client: HTTPClient,
                     callback: @escaping PaginatedTestListable.ListRequestCallback) {
        let endpoint = TestAPIEndpoint(path: "dummy.listable.failure")
        self.list(using: client, endpoint: endpoint, callback: callback)
    }
}
