//
//  OMGClient.swift
//  OmiseGO
//
//  Created by Mederic Petit on 9/10/2560 BE.
//  Copyright © 2560 OmiseGO. All rights reserved.
//

/// Represents an OMGClient that should be configured using an OMGConfiguration
public class OMGClient {

    /// The shared client that will be used by default if no client is specified.
    public static let shared = OMGClient()

    let authScheme = "OMGClient"
    let operationQueue: OperationQueue = OperationQueue()

    var session: URLSession!
    var config: OMGConfiguration!

    private init() {}

    /// Initialize a client using a configuration object
    ///
    /// - Parameter config: The configuration object
    public init(config: OMGConfiguration) {
        OMGClient.set(config, toClient: self)
    }

    @discardableResult
    /// A method used to setup the shared client with a configuration object
    ///
    /// - Parameter config: The configuration object
    /// - Returns: The shared client
    public static func setup(withConfig config: OMGConfiguration) -> OMGClient {
        return OMGClient.set(config, toClient: OMGClient.shared)
    }

    @discardableResult
    private static func set(_ config: OMGConfiguration, toClient client: OMGClient) -> OMGClient {
        client.config = config
        client.session = URLSession(configuration: URLSessionConfiguration.ephemeral,
                                    delegate: nil,
                                    delegateQueue: client.operationQueue)

        return client
    }

    @discardableResult
    func request<ResultType>(toEndpoint endpoint: APIEndpoint,
                             callback: OMGRequest<ResultType>.Callback?) -> OMGRequest<ResultType>? {
        guard self.config != nil else {
            let missingConfigMessage = """
               Missing client configuration. Add a configuration to the client
               using OMGClient.setup(withConfig: OMGConfiguration)
            """
            omiseGOWarn(missingConfigMessage)
            performCallback {
                callback?(.fail(error: .configuration(message: missingConfigMessage)))
            }

            return nil
        }
        do {
            let request: OMGRequest<ResultType> = OMGRequest(client: self, endpoint: endpoint, callback: callback)
            return try request.start()
        } catch let error as OmiseGOError {
            performCallback {
                callback?(.fail(error: error))
            }
        } catch let error {
            performCallback {
                callback?(.fail(error: .other(error: error)))
            }
        }

        return nil
    }

    func performCallback(_ callback: @escaping () -> Void) {
        OperationQueue.main.addOperation(callback)
    }

    public func cancelAllOperations() {
        session.invalidateAndCancel()
        operationQueue.cancelAllOperations()
    }

    func encodedAuthorizationHeader() throws -> String {
        guard let authenticationToken = self.config.authenticationToken else {
            throw OmiseGOError.configuration(message: "Please provide an authentication token before using the SDK")
        }
        let keys = "\(self.config.apiKey):\(authenticationToken)"
        let data = keys.data(using: .utf8, allowLossyConversion: false)
        guard let encodedKey = data?.base64EncodedString() else {
            throw OmiseGOError.configuration(message: "bad API key or authentication token (encoding failed.)")
        }

        return "\(authScheme) \(encodedKey)"
    }

    func contentTypeHeader() -> String {
        return "application/vnd.omisego.v\(self.config.apiVersion)+json; charset=utf-8"
    }

    func acceptHeader() -> String {
        return "application/vnd.omisego.v\(self.config.apiVersion)+json"
    }

}

extension OMGClient {

    /// Logout the current user (invalidate the provided authenticationToken).
    ///
    /// - callback: The closure called when the request is completed
    /// - Returns: An optional cancellable request.
    @discardableResult
    public func logout(withCallback callback: @escaping OMGRequest<EmptyResponse>.Callback)
        -> OMGRequest<EmptyResponse>? {
        let request: OMGRequest<EmptyResponse>? = self.request(toEndpoint: .logout) { (result) in
            switch result {
            case .success(data: let data):
                self.config.authenticationToken = nil
                callback(.success(data: data))
            case .fail(let error):
                callback(.fail(error: error))
            }
        }
        return request
    }

}
