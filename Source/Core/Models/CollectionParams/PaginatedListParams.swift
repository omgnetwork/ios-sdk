//
//  PaginatedListParams.swift
//  OmiseGO
//
//  Created by Mederic Petit on 17/9/18.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

import UIKit

public struct PaginatedListParams<T: PaginatedListable> {
    let sortParams: SortParams<T>
    let searchParams: SearchParams<T>?
    let paginationParams: PaginationParams

    /// Initialize the params used to query a paginated collection
    ///
    /// - Parameters:
    ///   - page: The page requested (0 and 1 are the same)
    ///   - perPage: The number of result expected per page
    ///   - sortBy: The field to sort by
    ///   - sortDirection: The sort direction (ascending or descending)
    public init(page: Int,
                perPage: Int,
                sortBy: T.SortableFields,
                sortDirection: SortDirection) {
        self.sortParams = SortParams<T>(sortBy: sortBy, sortDirection: sortDirection)
        self.paginationParams = PaginationParams(page: page, perPage: perPage)
        self.searchParams = nil
    }

    /// Initialize the params used to query a paginated collection
    ///
    /// - Parameters:
    ///   - page: The page requested (0 and 1 are the same)
    ///   - perPage: The number of result expected per page
    ///   - searchTerm: The global search term used to search in any of the SearchableFields
    ///   - sortBy: The field to sort by
    ///   - sortDirection: The sort direction (ascending or descending)
    public init(page: Int,
                perPage: Int,
                searchTerm: String,
                sortBy: T.SortableFields,
                sortDirection: SortDirection) {
        self.sortParams = SortParams<T>(sortBy: sortBy, sortDirection: sortDirection)
        self.searchParams = SearchParams<T>(searchTerm: searchTerm)
        self.paginationParams = PaginationParams(page: page, perPage: perPage)
    }

    /// Initialize the params used to query a paginated collection
    ///
    /// - Parameters:
    ///   - page: The page requested (0 and 1 are the same)
    ///   - perPage: The number of result expected per page
    ///   - searchTerms: A dictionary where each key is a Searchable field that and each value is a search term
    ///   - sortBy: The field to sort by
    ///   - sortDirection: The sort direction (ascending or descending)
    public init(page: Int,
                perPage: Int,
                searchTerms: [T.SearchableFields: Any],
                sortBy: T.SortableFields,
                sortDirection: SortDirection) {
        self.sortParams = SortParams<T>(sortBy: sortBy, sortDirection: sortDirection)
        self.searchParams = SearchParams<T>(searchTerms: searchTerms)
        self.paginationParams = PaginationParams(page: page, perPage: perPage)
    }
}

extension PaginatedListParams: APIParameters {
    public func encode(to encoder: Encoder) throws {
        try self.sortParams.encode(to: encoder)
        try self.searchParams?.encode(to: encoder)
        try self.paginationParams.encode(to: encoder)
    }
}
