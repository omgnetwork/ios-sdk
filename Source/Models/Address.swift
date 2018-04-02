//
//  Balance.swift
//  OmiseGO
//
//  Created by Thibault Denizet on 12/10/2017.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

/// Represents an address containing a list of balances
public struct Address: Retrievable, Decodable {

    /// The address of the balances
    public let address: String
    /// The list of balances associated with that address
    public let balances: [Balance]
}

extension Address: Listable {

    @discardableResult
    /// Get all addresses of the current user
    ///
    /// - Parameters:
    ///   - client: An API client.
    ///             This client need to be initialized with a OMGConfiguration struct before being used.
    ///   - callback: The closure called when the request is completed
    /// - Returns: An optional cancellable request.
    public static func getAll(using client: OMGHTTPClient,
                              callback: @escaping Address.ListRequestCallback) -> Address.ListRequest? {
        return self.list(using: client, endpoint: .getAddresses, callback: callback)
    }

    @discardableResult
    /// Get the main address for the current user
    ///
    /// - Parameters:
    ///   - client: An API client.
    ///             This client need to be initialized with a OMGConfiguration struct before being used.
    ///   - callback: The closure called when the request is completed
    /// - Returns: An optional cancellable request.
    public static func getMain(using client: OMGHTTPClient,
                               callback: @escaping Address.RetrieveRequestCallback) -> Address.ListRequest? {
        return self.list(using: client, endpoint: .getAddresses, callback: { (response) in
            switch response {
            case .success(data: let addresses):
                if addresses.isEmpty {
                    callback(Response.fail(error: OmiseGOError.unexpected(message: "No balance received.")))
                } else {
                    callback(.success(data: addresses.first!))
                }
            case .fail(error: let error):
                callback(.fail(error: error))
            }

        })
    }

}

extension Address: Hashable {

    public var hashValue: Int {
        return self.address.hashValue
    }

    public static func == (lhs: Address, rhs: Address) -> Bool {
        return lhs.address == rhs.address
    }

}
