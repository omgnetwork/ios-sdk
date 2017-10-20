//
//  Listable.swift
//  OmiseGO
//
//  Created by Mederic Petit on 12/10/2560 BE.
//  Copyright © 2560 OmiseGO. All rights reserved.
//

import UIKit

/// Represents an object that can be retrived in a collection
public protocol Listable {}

public extension Listable where Self: OmiseGOObject {
    public typealias ListRequest = APIRequest<ListProperty<Self>>
    public typealias ListRequestCallback = (Response<[Self], OmiseGOError>) -> Void

    @discardableResult
    internal static func list(using client: APIClient,
                              endpoint: APIEndpoint,
                              callback: @escaping ListRequestCallback) -> ListRequest? {
        return client.request(toEndpoint: endpoint, callback: { (result) in
            switch result {
            case .success(let list):
                callback(.success(list.data))
            case .fail(let error):
                callback(.fail(error))
            }
        })
    }
}
