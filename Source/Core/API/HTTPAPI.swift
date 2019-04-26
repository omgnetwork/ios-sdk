//
//  HTTPAPI.swift
//  OmiseGO
//
//  Created by Mederic Petit on 9/10/2017.
//  Copyright © 2017-2019 Omise Go Pte. Ltd. All rights reserved.
//

/// Represents an HTTPAPI that should be initialized using a Configuration
public class HTTPAPI {
    let operationQueue: OperationQueue = OperationQueue()

    lazy var session: URLSession = {
        URLSession(configuration: URLSessionConfiguration.ephemeral,
                   delegate: nil,
                   delegateQueue: self.operationQueue)
    }()

    var config: Configuration

    init(config: Configuration) {
        self.config = config
    }

    /// A boolean indicating if the client is authenticated and allowed to make authenticated requests
    public var isAuthenticated: Bool { return self.config.credentials.isAuthenticated() }

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
                callback?(.failure(error))
            }
        } catch let error as EncodingError {
            switch error {
            case let .invalidValue(_, context):
                performCallback {
                    callback?(.failure(.unexpected(message: context.debugDescription)))
                }
            @unknown default:
                performCallback {
                    callback?(.failure(.other(error: error)))
                }
            }
        } catch _ {
            self.performCallback {
                callback?(.failure(.unexpected(message: "Could not build the request")))
            }
        }

        return nil
    }

    private func performCallback(_ callback: @escaping () -> Void) {
        OperationQueue.main.addOperation(callback)
    }
}
