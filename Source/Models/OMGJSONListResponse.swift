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

extension OMGJSONListResponse: RandomAccessCollection {

    public subscript(index: Array<Item>.Index) -> Item {
        return data[index]
    }

    public subscript(bounds: Range<Array<Item>.Index>) -> ArraySlice<Item> {
        return data[bounds]
    }

    public var startIndex: (Array<Item>.Index) {
        return data.startIndex
    }

    public var endIndex: (Array<Item>.Index) {
        return data.endIndex
    }

}
