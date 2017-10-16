//
//  ListProperty.swift
//  OmiseGO
//
//  Created by Mederic Petit on 10/10/2560 BE.
//  Copyright © 2560 OmiseGO. All rights reserved.
//

import Foundation

public struct ListProperty<Item: OmiseGOObject>: OmiseGOObject {

    let data: [Item]

}

extension ListProperty: RandomAccessCollection {

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

extension ListProperty: Decodable {

    private enum CodingKeys: String, CodingKey {
        case data
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        data = try container.decode([Item].self, forKey: .data)
    }

}
