//
//  Pagination.swift
//  OmiseGO
//
//  Created by Mederic Petit on 23/2/18.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

/// Represents a pagination object contained in a paginated list response
public struct Pagination: Decodable {

    public let perPage: Int
    public let currentPage: Int
    public let isFirstPage: Bool
    public let isLastPage: Bool

    private enum CodingKeys: String, CodingKey {
        case perPage = "per_page"
        case currentPage = "current_page"
        case isFirstPage = "is_first_page"
        case isLastPage = "is_last_page"
    }

}
