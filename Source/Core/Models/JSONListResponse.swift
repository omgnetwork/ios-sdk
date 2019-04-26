//
//  JSONListResponse.swift
//  OmiseGO
//
//  Created by Mederic Petit on 10/10/2017.
//  Copyright © 2017-2019 Omise Go Pte. Ltd. All rights reserved.
//

/// Represents a list response containing a data array of generic items.
public struct JSONListResponse<Item: Decodable>: Decodable {
    let data: [Item]
}

/// Represents a list response containing a data array of generic items and a pagination object.
public struct JSONPaginatedListResponse<Item: Decodable>: Decodable {
    public let data: [Item]
    public let pagination: Pagination
}
