//
//  PaginatedListParams.swift
//  OmiseGO
//
//  Created by Mederic Petit on 17/9/18.
//  Copyright © 2017-2019 Omise Go Pte. Ltd. All rights reserved.
//

import UIKit

public protocol RawEnumerable: Hashable, RawRepresentable, Encodable {}

public struct PaginatedListParams<T: PaginatedListable> {
    let sortParams: SortParams<T>
    let filterParams: FilterParams<T>?
    let paginationParams: PaginationParams

    /// Initialize the params used to query a paginated collection
    ///
    /// - Parameters:
    ///   - page: The page requested (0 and 1 are the same)
    ///   - perPage: The number of result expected per page
    ///   - filters: A FilterParams struc used to filter the results
    ///   - sortBy: The field to sort by
    ///   - sortDirection: The sort direction (ascending or descending)
    public init(page: Int,
                perPage: Int,
                filters: FilterParams<T>? = nil,
                sortBy: T.SortableFields,
                sortDirection: SortDirection) {
        self.paginationParams = PaginationParams(page: page, perPage: perPage)
        self.filterParams = filters
        self.sortParams = SortParams<T>(sortBy: sortBy, sortDirection: sortDirection)
    }
}

extension PaginatedListParams: APIParameters {
    public func encode(to encoder: Encoder) throws {
        try self.sortParams.encode(to: encoder)
        try self.filterParams?.encode(to: encoder)
        try self.paginationParams.encode(to: encoder)
    }
}

extension PaginatedListable {
    public static func paginatedListParams(page: Int,
                                           perPage: Int,
                                           filters: FilterParams<Self>? = nil,
                                           sortBy: SortableFields,
                                           sortDirection: SortDirection) -> PaginatedListParams<Self> {
        return PaginatedListParams(page: page,
                                   perPage: perPage,
                                   filters: filters,
                                   sortBy: sortBy,
                                   sortDirection: sortDirection)
    }
}
