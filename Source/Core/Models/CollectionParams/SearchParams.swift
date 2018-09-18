//
//  SearchParams.swift
//  OmiseGO
//
//  Created by Mederic Petit on 17/9/18.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

public protocol Searchable {
    associatedtype SearchableFields: KeyEncodable where SearchableFields.RawValue == String
}

/// Represents a structure used to query a searchable list
struct SearchParams<T: Searchable> {
    /// The global search term used to search in any of the SearchableFields
    public let searchTerm: String?
    /// A dictionary where each key is a Searchable field that and each value is a search term
    public let searchTerms: [T.SearchableFields: Any]?

    /// Initialize the params used to query a searchable collection with a searchTerm attribute
    ///
    /// - Parameters:
    ///   - searchTerms: A global search term used to search in any of the SearchableFields
    public init(searchTerm: String? = nil) {
        self.searchTerm = searchTerm
        self.searchTerms = nil
    }

    /// Initialize the params used to query a searchable collection with a searchTerms attribute
    ///
    /// - Parameters:
    ///   - searchTerms: A dictionary where each key is a Searchable field that and each value is a search term
    public init(searchTerms: [T.SearchableFields: Any]? = nil) {
        self.searchTerms = searchTerms
        self.searchTerm = nil
    }
}

extension SearchParams: APIParameters {
    enum CodingKeys: String, CodingKey {
        case searchTerm = "search_term"
        case searchTerms = "search_terms"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        // If we have both searchTerm and searchTerms, we only encode searchTerms
        if self.searchTerm != nil, let searchTerms = self.encodableSearchTerms() {
            try container.encode(searchTerms, forKey: .searchTerms)
        } else {
            try container.encodeIfPresent(self.encodableSearchTerms(), forKey: .searchTerms)
            try container.encodeIfPresent(self.searchTerm, forKey: .searchTerm)
        }
    }

    private func encodableSearchTerms() -> [String: Any]? {
        guard let searchTerms = self.searchTerms else { return nil }
        var formattedSearchParams: [String: Any] = [:]
        searchTerms.forEach({ formattedSearchParams[$0.key.rawValue] = $0.value })
        return formattedSearchParams
    }
}
