//
//  Listable.swift
//  OmiseGO
//
//  Created by Mederic Petit on 12/10/2017.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

/// Represents an object that can be retrived in a collection
public protocol Listable {}

public extension Listable where Self: Decodable {
    public typealias ListRequest = OMGRequest<OMGJSONListResponse<Self>>
    public typealias ListRequestCallback = (Response<[Self]>) -> Void

    @discardableResult
    internal static func list(using client: OMGClient,
                              endpoint: APIEndpoint,
                              callback: @escaping ListRequestCallback) -> ListRequest? {
        return client.request(toEndpoint: endpoint, callback: { (result) in
            switch result {
            case .success(let list):
                callback(.success(data: list.data))
            case .fail(let error):
                callback(.fail(error: error))
            }
        })
    }
}

/// Represents an object that can be retrieved in a paginated collection
public protocol PaginatedListable {}

public extension PaginatedListable where Self: Decodable {
    public typealias ListRequest = OMGRequest<OMGJSONPaginatedListResponse<Self>>
    public typealias ListRequestCallback = (Response<OMGJSONPaginatedListResponse<Self>>) -> Void

    @discardableResult
    internal static func list(using client: OMGClient,
                              endpoint: APIEndpoint,
                              callback: @escaping ListRequestCallback) -> ListRequest? {
        return client.request(toEndpoint: endpoint, callback: { (result) in
            switch result {
            case .success(let list):
                callback(.success(data: list))
            case .fail(let error):
                callback(.fail(error: error))
            }
        })
    }
}
