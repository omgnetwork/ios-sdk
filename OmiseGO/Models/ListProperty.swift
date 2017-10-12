//
//  ListProperty.swift
//  OmiseGO
//
//  Created by Mederic Petit on 10/10/2560 BE.
//  Copyright © 2560 OmiseGO. All rights reserved.
//

import Foundation

public struct ListProperty<Item: OmiseGOObject>: OmiseGOObject {

    public let object: String
    public let data: [Item]

    public subscript(index: Array<Item>.Index) -> Item {
        return data[index]
    }

    public subscript(bounds: Range<Array<Item>.Index>) -> ArraySlice<Item> {
        return data[bounds]
    }

}

extension ListProperty: RandomAccessCollection {
    /// The position of the first element in a nonempty collection.
    ///
    /// If the collection is empty, `startIndex` is equal to `endIndex`.
    public var startIndex: (Array<Item>.Index) {
        return data.startIndex
    }

    public var endIndex: (Array<Item>.Index) {
        return data.endIndex
    }
}
