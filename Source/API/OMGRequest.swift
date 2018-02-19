//
//  OMGRequest.swift
//  OmiseGO
//
//  Created by Mederic Petit on 9/10/2560 BE.
//  Copyright © 2560 OmiseGO. All rights reserved.
//

/// Represents a cancellable request
public class OMGRequest<ResultType: Decodable> {

    public typealias Callback = (Response<ResultType>) -> Void

    let client: OMGClient
    let endpoint: APIEndpoint
    let callback: OMGRequest.Callback?

    var task: URLSessionTask?

    init(client: OMGClient, endpoint: APIEndpoint, callback: Callback?) {
        self.client = client
        self.endpoint = endpoint
        self.callback = callback
    }

    /// Cancel the request
    public func cancel() {
        task?.cancel()
    }

    func start() throws -> Self {
        guard let urlRequest = try buildURLRequest() else {
            throw OmiseGOError.configuration(message: "Invalid request")
        }
        let dataTask = client.session.dataTask(with: urlRequest, completionHandler: didComplete)
        self.task = dataTask
        dataTask.resume()

        return self
    }

    fileprivate func didComplete(_ data: Data?, response: URLResponse?, error: Error?) {
        // no one's in the forest to hear the leaf falls.
        guard callback != nil else { return }

        if let error = error {
            performCallback(.fail(error: .other(error: error)))
            return
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            performCallback(.fail(error: .unexpected(message: "no error and no response.")))
            return
        }

        guard let data = data else {
            performCallback(.fail(error: .unexpected(message: "empty response.")))
            return
        }
        performCallback(self.result(withData: data, statusCode: httpResponse.statusCode))
    }

    fileprivate func result(withData data: Data, statusCode: Int) -> Response<ResultType> {
        guard [200, 500].contains(statusCode) else {
            return .fail(error: .unexpected(message: "unrecognized HTTP status code: \(statusCode)"))
        }
        do {
            let response: OMGJSONResponse<ResultType> = try deserializeData(data)
            return response.data
        } catch let error {
            return .fail(error: .other(error: error))
        }
    }

    fileprivate func performCallback(_ result: Response<ResultType>) {
        guard let cb = callback else { return }
        OperationQueue.main.addOperation({ cb(result) })
    }

    func buildURLRequest() throws -> URLRequest? {
        guard let requestURL = endpoint.makeURL(withBaseURL: self.client.config.baseURL) else {
            throw OmiseGOError.configuration(message: "Invalid request")
        }

        let auth = try client.encodedAuthorizationHeader()

        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        request.cachePolicy = .useProtocolCachePolicy
        request.timeoutInterval = 6.0
        request.addValue(auth, forHTTPHeaderField: "Authorization")
        request.addValue(client.acceptHeader(), forHTTPHeaderField: "Accept")
        request.addValue(client.contentTypeHeader(), forHTTPHeaderField: "Content-Type")
        endpoint.additionalHeaders?.forEach({ (key, value) in
            request.addValue(value, forHTTPHeaderField: key)
        })

        switch endpoint.task {
        case .requestPlain: break
        case .requestParameters(let parameters):
            if let payload: Data = parameters.encodedPayload() {
                request.httpBody = payload
                request.addValue(String(payload.count), forHTTPHeaderField: "Content-Length")
            }
        }
        return request
    }

}
