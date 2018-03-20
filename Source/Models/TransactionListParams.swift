//
//  TransactionListParams.swift
//  OmiseGO
//
//  Created by Mederic Petit on 23/2/18.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

import UIKit

// Represent a structure used to query a list of transactions
public struct TransactionListParams {

    public let paginationParams: PaginationParams<Transaction>
    /// An optional address owned by the current user
    public let address: String?

    public init(paginationParams: PaginationParams<Transaction>, address: String?) {
        self.paginationParams = paginationParams
        self.address = address
    }

}

extension TransactionListParams: Parametrable {

    private enum CodingKeys: String, CodingKey {
        case paginationParams
        case address
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(address, forKey: .address)
        try paginationParams.encode(to: encoder)
    }

    func encodedPayload() -> Data? {
        return try? JSONEncoder().encode(self)
    }

}
