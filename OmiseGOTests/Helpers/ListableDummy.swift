//
//  ListableDummy.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 7/3/18.
//  Copyright © 2018 OmiseGO. All rights reserved.
//

@testable import OmiseGO

struct ListableDummy: Decodable, Listable {

    static func list(using client: OMGClient,
                     callback: @escaping ListRequestCallback) {
        let endpoint = APIEndpoint.custom(path: "dummy.listable.failure", task: .requestPlain)
        self.list(using: client, endpoint: endpoint, callback: callback)
    }

}

struct PaginatedListableDummy: Decodable, PaginatedListable {

    static func list(using client: OMGClient,
                     callback: @escaping PaginatedListableDummy.ListRequestCallback) {
        let endpoint = APIEndpoint.custom(path: "dummy.listable.failure", task: .requestPlain)
        self.list(using: client, endpoint: endpoint, callback: callback)
    }

}
