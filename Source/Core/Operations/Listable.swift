//
//  Listable.swift
//  OmiseGO
//
//  Created by Mederic Petit on 12/10/2017.
//  Copyright © 2017-2019 Omise Go Pte. Ltd. All rights reserved.
//

/// Represents an object that can be retrived in a collection
public protocol Listable {}

public extension Listable where Self: Decodable {
    typealias ListRequest = Request<JSONListResponse<Self>>
    typealias ListRequestCallback = (Response<[Self]>) -> Void

    @discardableResult
    internal static func list(using client: HTTPAPI,
                              endpoint: APIEndpoint,
                              callback: @escaping ListRequestCallback) -> ListRequest? {
        return client.request(toEndpoint: endpoint, callback: { result in
            switch result {
            case let .success(list):
                callback(.success(list.data))
            case let .failure(error):
                callback(.failure(error))
            }
        })
    }
}

/// Represents an object that can be retrieved in a paginated collection
public protocol PaginatedListable: Filterable, Sortable {}

public extension PaginatedListable where Self: Decodable {
    typealias PaginatedListRequest = Request<JSONPaginatedListResponse<Self>>
    typealias PaginatedListRequestCallback = (Response<JSONPaginatedListResponse<Self>>) -> Void

    @discardableResult
    internal static func list(using client: HTTPAPI,
                              endpoint: APIEndpoint,
                              callback: @escaping PaginatedListRequestCallback) -> PaginatedListRequest? {
        return client.request(toEndpoint: endpoint, callback: { result in
            switch result {
            case let .success(list):
                callback(.success(list))
            case let .failure(error):
                callback(.failure(error))
            }
        })
    }
}
