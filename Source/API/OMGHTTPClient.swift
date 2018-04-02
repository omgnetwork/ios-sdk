//
//  OMGHTTPClient.swift
//  OmiseGO
//
//  Created by Mederic Petit on 9/10/2017.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

/// Represents an OMGHTTPClient that should be initialized using an OMGConfiguration
public class OMGHTTPClient {

    let operationQueue: OperationQueue = OperationQueue()

    var session: URLSession!
    var config: OMGConfiguration

    /// Initialize a client using a configuration object
    ///
    /// - Parameter config: The configuration object
    public init(config: OMGConfiguration) {
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
                             callback: OMGRequest<ResultType>.Callback?) -> OMGRequest<ResultType>? {
        do {
            let request: OMGRequest<ResultType> = OMGRequest(client: self,
                                                             endpoint: endpoint,
                                                             callback: callback)
            return try request.start()
        } catch let error as OmiseGOError {
            performCallback {
                callback?(.fail(error: error))
            }
        } catch {}

        return nil
    }

    private func performCallback(_ callback: @escaping () -> Void) {
        OperationQueue.main.addOperation(callback)
    }

}

extension OMGHTTPClient {

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
