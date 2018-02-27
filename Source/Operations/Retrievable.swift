//
//  Retrievable.swift
//  OmiseGO
//
//  Created by Mederic Petit on 11/10/2017 BE.
//  Copyright © 2017 OmiseGO. All rights reserved.
//

/// Represent an Object that can be uniquely retrived
public protocol Retrievable {}

public extension Retrievable where Self: Decodable {
    public typealias RetrieveRequest = OMGRequest<Self>
    public typealias RetrieveRequestCallback = RetrieveRequest.Callback

    @discardableResult
    internal static func retrieve(using client: OMGClient,
                                  endpoint: APIEndpoint,
                                  callback: @escaping RetrieveRequestCallback) -> RetrieveRequest? {
        return client.request(toEndpoint: endpoint, callback: callback)
    }
}
