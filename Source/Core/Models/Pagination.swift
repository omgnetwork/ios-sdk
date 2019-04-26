//
//  Pagination.swift
//  OmiseGO
//
//  Created by Mederic Petit on 23/2/18.
//  Copyright © 2017-2019 Omise Go Pte. Ltd. All rights reserved.
//

/// Represents a pagination object contained in a paginated list response
public struct Pagination: Decodable {
    /// The number of result per page
    public let perPage: Int
    /// The current page requested
    public let currentPage: Int
    /// Indicates if the page requested is the first one
    public let isFirstPage: Bool
    /// Indicates if the page requested is the last one
    public let isLastPage: Bool

    private enum CodingKeys: String, CodingKey {
        case perPage = "per_page"
        case currentPage = "current_page"
        case isFirstPage = "is_first_page"
        case isLastPage = "is_last_page"
    }
}
