//
//  ListableDummy.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 7/3/18.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

@testable import OmiseGO

struct ListableDummy: Decodable, Listable {

    static func list(using client: OMGHTTPClient,
                     callback: @escaping ListRequestCallback) {
        let endpoint = APIEndpoint.custom(path: "dummy.listable.failure", task: .requestPlain)
        self.list(using: client, endpoint: endpoint, callback: callback)
    }

}

struct PaginatedListableDummy: Decodable, PaginatedListable {

    static func list(using client: OMGHTTPClient,
                     callback: @escaping PaginatedListableDummy.ListRequestCallback) {
        let endpoint = APIEndpoint.custom(path: "dummy.listable.failure", task: .requestPlain)
        self.list(using: client, endpoint: endpoint, callback: callback)
    }

}
