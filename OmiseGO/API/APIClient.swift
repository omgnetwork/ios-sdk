//
//  APIClient.swift
//  OmiseGO
//
//  Created by Mederic Petit on 9/10/2560 BE.
//  Copyright © 2560 OmiseGO. All rights reserved.
//

import Foundation

public class APIClient {

    public static let sessionIdentifier = "omg.omise.co"
    let authScheme = "OMGClient"

    var session: URLSession!
    let operationQueue: OperationQueue

    let config: APIConfiguration

    public init(config: APIConfiguration) {
        self.config = config
        self.operationQueue = OperationQueue()
        self.session = URLSession(configuration: URLSessionConfiguration.ephemeral,
                                  delegate: nil,
                                  delegateQueue: operationQueue)
    }

    @discardableResult
    public func request<ResultType>(toEndpoint endpoint: APIEndpoint<ResultType>,
                                    callback: APIRequest<ResultType>.Callback?) -> APIRequest<ResultType>? {
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
