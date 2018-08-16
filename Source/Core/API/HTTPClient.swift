//
//  HTTPClient.swift
//  OmiseGO
//
//  Created by Mederic Petit on 9/10/2017.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

/// Represents an HTTPClient that should be initialized using a Configuration
public class HTTPClient {
    let operationQueue: OperationQueue = OperationQueue()

    lazy var session: URLSession! = {
        URLSession(configuration: URLSessionConfiguration.ephemeral,
                   delegate: nil,
                   delegateQueue: self.operationQueue)
    }()

    var config: Configuration!

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
            case let .invalidValue(_, context):
                performCallback {
                    callback?(.fail(error: OMGError.unexpected(message: context.debugDescription)))
                }
            }
        } catch _ {
            self.performCallback {
                callback?(.fail(error: OMGError.unexpected(message: "Could not build the request")))
            }
        }

        return nil
    }

    private func performCallback(_ callback: @escaping () -> Void) {
        OperationQueue.main.addOperation(callback)
    }
}
