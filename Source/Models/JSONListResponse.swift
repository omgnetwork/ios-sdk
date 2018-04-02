//
//  JSONListResponse.swift
//  OmiseGO
//
//  Created by Mederic Petit on 10/10/2017.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

/// A struct representing a list response containing a data array of items.
public struct JSONListResponse<Item: Decodable>: Decodable {

    let data: [Item]

}

/// A struct representing a list response containing a data array of items and a pagination object.
public struct JSONPaginatedListResponse<Item: Decodable>: Decodable {

    public let data: [Item]
    public let pagination: Pagination

}
