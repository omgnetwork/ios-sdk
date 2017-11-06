//
//  OMGJSONListResponse.swift
//  OmiseGO
//
//  Created by Mederic Petit on 10/10/2560 BE.
//  Copyright © 2560 OmiseGO. All rights reserved.
//

import Foundation

/// A struct representing a list response containing a data array of items.
public struct OMGJSONListResponse<Item: Decodable> {

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

extension OMGJSONListResponse: Decodable {

    private enum CodingKeys: String, CodingKey {
        case data
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        data = try container.decode([Item].self, forKey: .data)
    }

}
