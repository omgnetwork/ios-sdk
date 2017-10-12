//
//  Retrievable.swift
//  OmiseGO
//
//  Created by Mederic Petit on 11/10/2560 BE.
//  Copyright © 2560 OmiseGO. All rights reserved.
//

import Foundation

public protocol Retrievable {}

public extension Retrievable where Self: OmiseGOLocatableObject {
    public typealias RetrieveEndpoint = APIEndpoint<Self>
    public typealias RetrieveRequest = APIRequest<Self>

    public static func retrieveEndpoint() -> RetrieveEndpoint {
        return RetrieveEndpoint(action: self.operation)
    }

    @discardableResult
    public static func retrieve(using client: APIClient,
                                callback: @escaping RetrieveRequest.Callback) -> RetrieveRequest? {
        let endpoint = self.retrieveEndpoint()

        return client.request(toEndpoint: endpoint, callback: callback)
    }
}
