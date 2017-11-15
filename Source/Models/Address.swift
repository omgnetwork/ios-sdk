//
//  Balance.swift
//  OmiseGO
//
//  Created by Thibault Denizet on 12/10/2560 BE.
//  Copyright © 2560 OmiseGO. All rights reserved.
//

/// Represents an address containing a list of balances
public struct Address: Retrievable {

    /// The address of the balances
    public let address: String
    /// The list of balances associated with that address
    public let balances: [Balance]
}

extension Address: Decodable {

    private enum CodingKeys: String, CodingKey {
        case address
        case balances
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        address = try container.decode(String.self, forKey: .address)
        balances = try container.decode([Balance].self, forKey: .balances)
    }

}

extension Address: Listable {

    @discardableResult
    /// Get all addresses of the current user
    ///
    /// - Parameters:
    ///   - client: An optional API client (use the shared client by default).
    ///             This client need to be initialized with a OMGConfiguration struct before being used.
    ///   - callback: The closure called when the request is completed
    /// - Returns: An optional cancellable request.
    public static func getAll(using client: OMGClient = OMGClient.shared,
                              callback: @escaping Address.ListRequestCallback) -> Address.ListRequest? {
        return self.list(using: client, endpoint: .getAddresses, callback: callback)
    }

    @discardableResult
    /// Get the main address for the current user
    ///
    /// - Parameters:
    ///   - client: An optional API client (use the shared client by default).
    ///             This client need to be initialized with a OMGConfiguration struct before being used.
    ///   - callback: The closure called when the request is completed
    /// - Returns: An optional cancellable request.
    public static func getMain(using client: OMGClient = OMGClient.shared,
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
