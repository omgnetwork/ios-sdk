//
//  SortParams.swift
//  OmiseGO
//
//  Created by Mederic Petit on 17/9/18.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

/// The desired sort direction
///
/// - ascending: Ascending
/// - descending: Descending
public enum SortDirection: String, Encodable {
    case ascending = "asc"
    case descending = "desc"
}

public protocol Sortable {
    associatedtype SortableFields: KeyEncodable where SortableFields.RawValue == String
}

/// Represents a structure used to query a sortable list
struct SortParams<T: Sortable> {
    /// The field to sort by
    public let sortBy: T.SortableFields
    /// The sort direction (ascending or descending)
    public let sortDirection: SortDirection

    /// Initialize the params used to query a sortable collection
    ///
    /// - Parameters:
    ///   - sortBy: The field to sort by
    ///   - sortDirection: The sort direction (ascending or descending)
    public init(sortBy: T.SortableFields,
                sortDirection: SortDirection) {
        self.sortBy = sortBy
        self.sortDirection = sortDirection
    }
}

extension SortParams: APIParameters {
    enum CodingKeys: String, CodingKey {
        case sortBy = "sort_by"
        case sortDirection = "sort_dir"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.sortBy, forKey: .sortBy)
        try container.encode(self.sortDirection, forKey: .sortDirection)
    }
}
