//
//  PaginationParams.swift
//  OmiseGO
//
//  Created by Mederic Petit on 23/2/18.
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

public protocol KeyEncodable: Hashable, RawRepresentable, Encodable {}
public protocol Paginable: Sortable, Searchable {}

public protocol Sortable {
    associatedtype SortableFields: KeyEncodable where SortableFields.RawValue == String
}

public protocol Searchable {
    associatedtype SearchableFields: KeyEncodable where SearchableFields.RawValue == String
}

/// Represents a structure used to query and filter a list
public struct PaginationParams<T: Paginable> {

    /// The page requested (0 and 1 are the same)
    public let page: Int
    /// The number of result expected per page
    public let perPage: Int
    /// The global search term used to search in any of the SearchableFields
    public let searchTerm: String?
    /// A dictionary where each key is a Searchable field that and each value is a search term
    public let searchTerms: [T.SearchableFields: Any]?
    /// The field to sort by
    public let sortBy: T.SortableFields
    /// The sort direction (ascending or descending)
    public let sortDirection: SortDirection

    init(page: Int,
         perPage: Int,
         searchTerm: String?,
         searchTerms: [T.SearchableFields: Any]?,
         sortBy: T.SortableFields,
         sortDirection: SortDirection) {
        self.page = page
        self.perPage = perPage
        self.searchTerm = searchTerm
        self.searchTerms = searchTerms
        self.sortBy = sortBy
        self.sortDirection = sortDirection
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
                searchTerm: String? = nil,
                sortBy: T.SortableFields,
                sortDirection: SortDirection) {
        self.init(page: page, perPage: perPage, searchTerm: searchTerm, searchTerms: nil, sortBy: sortBy, sortDirection: sortDirection)
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
                searchTerms: [T.SearchableFields: Any]? = nil,
                sortBy: T.SortableFields,
                sortDirection: SortDirection) {
        self.init(page: page, perPage: perPage, searchTerm: nil, searchTerms: searchTerms, sortBy: sortBy, sortDirection: sortDirection)
    }

}

extension PaginationParams: APIParameters {

    enum CodingKeys: String, CodingKey {
        case page
        case perPage = "per_page"
        case searchTerm = "search_term"
        case searchTerms = "search_terms"
        case sortBy = "sort_by"
        case sortDirection = "sort_dir"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(page, forKey: .page)
        try container.encode(perPage, forKey: .perPage)
        // If we have both searchTerm and searchTerms, we only encode searchTerms
        if self.searchTerm != nil, let searchTerms = self.encodableSearchTerms() {
            try container.encode(searchTerms, forKey: .searchTerms)
        } else {
            try container.encodeIfPresent(self.encodableSearchTerms(), forKey: .searchTerms)
            try container.encodeIfPresent(searchTerm, forKey: .searchTerm)
        }
        try container.encode(sortBy, forKey: .sortBy)
        try container.encode(sortDirection, forKey: .sortDirection)
    }

    private func encodableSearchTerms() -> [String: Any]? {
        guard let searchTerms = self.searchTerms else { return nil }
        var formattedSearchParams: [String: Any] = [:]
        searchTerms.forEach({formattedSearchParams[$0.key.rawValue] = $0.value})
        return formattedSearchParams
    }

}
