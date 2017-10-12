//
//  Listable.swift
//  OmiseGO
//
//  Created by Mederic Petit on 12/10/2560 BE.
//  Copyright © 2560 OmiseGO. All rights reserved.
//

import UIKit

public protocol Listable {}

public extension Listable where Self: OmiseGOLocatableObject {
    public typealias ListEndpoint = APIEndpoint<ListProperty<Self>>
    public typealias ListRequest = APIRequest<ListProperty<Self>>

    public static func listEndpoint() -> ListEndpoint {
        return ListEndpoint(action: self.operation)
    }

    @discardableResult
    public static func list(using client: APIClient,
                            callback: @escaping ListRequest.Callback) -> ListRequest? {
        let endpoint = self.listEndpoint()

        return client.request(toEndpoint: endpoint, callback: callback)
    }
}
