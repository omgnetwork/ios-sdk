//
//  Listable.swift
//  OmiseGO
//
//  Created by Mederic Petit on 12/10/2017 BE.
//  Copyright © 2017 OmiseGO. All rights reserved.
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
