//
//  Retrievable.swift
//  OmiseGO
//
//  Created by Mederic Petit on 11/10/2560 BE.
//  Copyright © 2560 OmiseGO. All rights reserved.
//

import Foundation

/// Represent an Object that can be uniquely retrived
public protocol Retrievable {}

public extension Retrievable where Self: OmiseGOLocatableObject {
    internal typealias RetrieveEndpoint = APIEndpoint<Self>
    public typealias RetrieveRequest = APIRequest<Self>
    public typealias RetrieveRequestCallback = RetrieveRequest.Callback

    @discardableResult
    internal static func retrieve(using client: APIClient,
                                  callback: @escaping RetrieveRequestCallback) -> RetrieveRequest? {
        let endpoint = RetrieveEndpoint(action: self.operation)
        return client.request(toEndpoint: endpoint, callback: callback)
    }
}
