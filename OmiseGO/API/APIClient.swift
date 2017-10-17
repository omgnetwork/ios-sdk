//
//  APIClient.swift
//  OmiseGO
//
//  Created by Mederic Petit on 9/10/2560 BE.
//  Copyright © 2560 OmiseGO. All rights reserved.
//

import Foundation

/// Represents an APIClient that should be configured using an APIConfiguration
public class APIClient {

    /// The shared client that will be used by default if no client is specified.
    public static let shared = APIClient()

    let authScheme = "OMGClient"
    let operationQueue: OperationQueue = OperationQueue()

    var session: URLSession!
    var config: APIConfiguration!

    private init() {}

    /// Initialize a client using a configuration object
    ///
    /// - Parameter config: The configuration object
    public init(config: APIConfiguration) {
        APIClient.set(config, toClient: self)
    }

    @discardableResult
    /// A method used to setup the shared client with a configuration object
    ///
    /// - Parameter config: The configuration object
    /// - Returns: The shared client
    public static func setup(withConfig config: APIConfiguration) -> APIClient {
        return APIClient.set(config, toClient: APIClient.shared)
    }

    @discardableResult
    private static func set(_ config: APIConfiguration, toClient client: APIClient) -> APIClient {
        client.config = config
        client.session = URLSession(configuration: URLSessionConfiguration.ephemeral,
                                              delegate: nil,
                                              delegateQueue: client.operationQueue)

        return client
    }

    @discardableResult
    func request<ResultType>(toEndpoint endpoint: APIEndpoint<ResultType>,
                             callback: APIRequest<ResultType>.Callback?) -> APIRequest<ResultType>? {
        guard self.config != nil else {
            let missingConfigMessage = """
               Missing client configuration. Add a configuration to the client
               using APIClient.setup(withConfig: APIConfiguration)
            """
            omiseGOWarn(missingConfigMessage)
            performCallback {
                callback?(.fail(.configuration(missingConfigMessage)))
            }

            return nil
        }
        do {
            let req: APIRequest<ResultType> = APIRequest(client: self, endpoint: endpoint, callback: callback)
            return try req.start()
        } catch let err as OmiseGOError {
            performCallback {
                callback?(.fail(err))
            }
        } catch let err {
            performCallback {
                callback?(.fail(.other(err)))
            }
        }

        return nil
    }

    func performCallback(_ callback: @escaping () -> Void) {
        operationQueue.addOperation(callback)
    }

    public func cancelAllOperations() {
        session.invalidateAndCancel()
        operationQueue.cancelAllOperations()
    }

    func encodedAuthorizationHeader() throws -> String {
        let keys = "\(self.config.apiKey):\(self.config.authenticationToken)"
        let data = keys.data(using: .utf8, allowLossyConversion: false)
        guard let encodedKey = data?.base64EncodedString() else {
            throw OmiseGOError.configuration("bad API key or authentication token (encoding failed.)")
        }

        return "\(authScheme) \(encodedKey)"
    }

    func contentTypeHeader() -> String {
        return "application/vnd.omisego.v\(self.config.apiVersion)+json"
    }

}
