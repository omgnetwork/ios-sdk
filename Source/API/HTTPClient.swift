//
//  HTTPClient.swift
//  OmiseGO
//
//  Created by Mederic Petit on 9/10/2017.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

/// Represents an HTTPClient that should be initialized using an ClientConfiguration
public class HTTPClient {

    let operationQueue: OperationQueue = OperationQueue()

    var session: URLSession!
    var config: ClientConfiguration

    /// Initialize a client using a configuration object
    ///
    /// - Parameter config: The configuration object
    public init(config: ClientConfiguration) {
        self.config = config
        self.session = URLSession(configuration: URLSessionConfiguration.ephemeral,
                                  delegate: nil,
                                  delegateQueue: self.operationQueue)
    }

    /// Update the configured authentication token for future requests
    ///
    /// - Parameter token: The updated authentication token
    public func updateAuthenticationToken(_ token: String) {
        self.config.authenticationToken = token
    }

    @discardableResult
    func request<ResultType>(toEndpoint endpoint: APIEndpoint,
                             callback: Request<ResultType>.Callback?) -> Request<ResultType>? {
        do {
            let request: Request<ResultType> = Request(client: self,
                                                       endpoint: endpoint,
                                                       callback: callback)
            return try request.start()
        } catch let error as OMGError {
            performCallback {
                callback?(.fail(error: error))
            }
        } catch let error as EncodingError {
            switch error {
            case .invalidValue(_, let context):
                performCallback {
                    callback?(.fail(error: OMGError.unexpected(message: context.debugDescription)))
                }
            }
        } catch _ {
            performCallback {
                callback?(.fail(error: OMGError.unexpected(message: "Could not build the request")))
            }
        }

        return nil
    }

    private func performCallback(_ callback: @escaping () -> Void) {
        OperationQueue.main.addOperation(callback)
    }

}

extension HTTPClient {

    /// Logout the current user (invalidate the provided authenticationToken).
    ///
    /// - callback: The closure called when the request is completed
    /// - Returns: An optional cancellable request.
    @discardableResult
    public func logout(withCallback callback: @escaping Request<EmptyResponse>.Callback)
        -> Request<EmptyResponse>? {
        let request: Request<EmptyResponse>? = self.request(toEndpoint: .logout) { (result) in
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
