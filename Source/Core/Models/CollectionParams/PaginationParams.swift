//
//  PaginationParams.swift
//  OmiseGO
//
//  Created by Mederic Petit on 17/9/18.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

/// Represents a structure used to query a paginated list
struct PaginationParams {
    /// The page requested (0 and 1 are the same)
    public let page: Int
    /// The number of result expected per page
    public let perPage: Int

    /// Initialize the params used to query a paginated collection
    ///
    /// - Parameters:
    ///   - page: The page requested (0 and 1 are the same)
    ///   - perPage: The number of result expected per page
    public init(page: Int,
                perPage: Int) {
        self.page = page
        self.perPage = perPage
    }
}

extension PaginationParams: APIParameters {
    enum CodingKeys: String, CodingKey {
        case page
        case perPage = "per_page"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(page, forKey: .page)
        try container.encode(perPage, forKey: .perPage)
    }
}
