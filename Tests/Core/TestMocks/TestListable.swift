//
//  TestListable.swift
//  Tests
//
//  Created by Mederic Petit on 7/3/18.
//  Copyright © 2017-2019 Omise Go Pte. Ltd. All rights reserved.
//

@testable import OmiseGO

struct TestListable: Decodable, Listable {
    static func list(using client: HTTPAPI,
                     callback: @escaping ListRequestCallback) {
        let endpoint = TestAPIEndpoint(path: "dummy.listable.failure")
        self.list(using: client, endpoint: endpoint, callback: callback)
    }
}

struct PaginatedTestListable: Decodable, PaginatedListable {
    let dummy: String = "123"

    enum FilterableFields: String, RawEnumerable {
        case dummy
    }

    enum SortableFields: String, RawEnumerable {
        case dummy
    }

    static func list(using client: HTTPAPI,
                     callback: @escaping PaginatedTestListable.PaginatedListRequestCallback) {
        let endpoint = TestAPIEndpoint(path: "dummy.listable.failure")
        self.list(using: client, endpoint: endpoint, callback: callback)
    }
}
