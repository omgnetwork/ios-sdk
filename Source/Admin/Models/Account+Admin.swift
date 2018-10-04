//
//  Account+Admin.swift
//  OmiseGO
//
//  Created by Mederic Petit on 18/9/18.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

extension Account: Searchable {
    public enum SearchableFields: String, KeyEncodable {
        case id
        case name
        case description
    }
}

extension Account: Sortable {
    public enum SortableFields: String, KeyEncodable {
        case id
        case name
        case description
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

extension Account: PaginatedListable {
    @discardableResult
    /// Get a paginated list of accounts
    ///
    /// - Parameters:
    ///   - client: An API client.
    ///             This client need to be initialized with a AdminConfiguration struct before being used.
    ///   - params: The pagination params object to use to scope the results
    ///   - callback: The closure called when the request is completed
    /// - Returns: An optional cancellable request.
    public static func list(using client: HTTPAdminAPI,
                            params: PaginatedListParams<Account>,
                            callback: @escaping Account.PaginatedListRequestCallback) -> Account.PaginatedListRequest? {
        return self.list(using: client, endpoint: APIAdminEndpoint.getAccounts(params: params), callback: callback)
    }
}
