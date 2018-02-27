//
//  PaginationParams.swift
//  OmiseGO
//
//  Created by Mederic Petit on 23/2/18.
//  Copyright © 2018 OmiseGO. All rights reserved.
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

    public let page: Int
    public let perPage: Int
    public let searchTerm: String?
    public let searchTerms: [T.SearchableFields: Any]?
    public let sortBy: T.SortableFields
    public let sortDirection: SortDirection

    public init(page: Int,
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

}

extension PaginationParams: Parametrable {

    enum CodingKeys: String, CodingKey {
        case page
        case perPage = "per_page"
        case searchTerm = "search_term"
        case searchTerms = "search_terms"
        case sortBy = "sort_by"
        case sortDirection = "sort_dir"
    }

    func encodedPayload() -> Data? {
        return try? JSONEncoder().encode(self)
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
