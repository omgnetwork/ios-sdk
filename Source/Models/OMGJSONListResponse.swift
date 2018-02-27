//
//  OMGJSONListResponse.swift
//  OmiseGO
//
//  Created by Mederic Petit on 10/10/2017 BE.
//  Copyright © 2017 OmiseGO. All rights reserved.
//

/// A struct representing a list response containing a data array of items.
public struct OMGJSONListResponse<Item: Decodable>: Decodable {

    let data: [Item]

}

/// A struct representing a list response containing a data array of items and a pagination object.
public struct OMGJSONPaginatedListResponse<Item: Decodable>: Decodable {

    public let data: [Item]
    public let pagination: Pagination

}
