//
//  Retrievable.swift
//  OmiseGO
//
//  Created by Mederic Petit on 11/10/2017.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

/// Represent an Object that can be uniquely retrived
public protocol Retrievable {}

public extension Retrievable where Self: Decodable {
    public typealias RetrieveRequest = Request<Self>
    public typealias RetrieveRequestCallback = RetrieveRequest.Callback

    @discardableResult
    internal static func retrieve<T: APIEndpoint>(using client: HTTPAPI,
                                                  endpoint: T,
                                                  callback: @escaping RetrieveRequestCallback) -> RetrieveRequest? {
        return client.request(toEndpoint: endpoint, callback: callback)
    }

    @discardableResult
    internal func retrieve<T: APIEndpoint>(using client: HTTPAPI,
                                           endpoint: T,
                                           callback: @escaping RetrieveRequestCallback) -> RetrieveRequest? {
        return client.request(toEndpoint: endpoint, callback: callback)
    }
}
