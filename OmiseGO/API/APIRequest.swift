//
//  APIRequest.swift
//  OmiseGO
//
//  Created by Mederic Petit on 9/10/2560 BE.
//  Copyright © 2560 OmiseGO. All rights reserved.
//

import Foundation

/// Represents a cancellable request
public class APIRequest<ResultType: OmiseGOObject> {
    typealias Endpoint = APIEndpoint
    public typealias Callback = (Response<ResultType, OmiseGOError>) -> Void

    let client: APIClient
    let endpoint: APIRequest.Endpoint
    let callback: APIRequest.Callback?

    var task: URLSessionTask?

    init(client: APIClient, endpoint: Endpoint, callback: Callback?) {
        self.client = client
        self.endpoint = endpoint
        self.callback = callback
    }

    /// Cancel the request
    public func cancel() {
        task?.cancel()
    }

    func start() throws -> Self {
        guard let urlRequest = try makeURLRequest() else {
            throw OmiseGOError.configuration("Invalid request")
        }
        let dataTask = client.session.dataTask(with: urlRequest, completionHandler: didComplete)
        self.task = dataTask
        dataTask.resume()

        return self
    }

    fileprivate func didComplete(_ data: Data?, response: URLResponse?, error: Error?) {
        // no one's in the forest to hear the leaf falls.
        guard callback != nil else { return }

        if let err = error {
            performCallback(.fail(.other(err)))
            return
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            performCallback(.fail(.unexpected("no error and no response.")))
            return
        }

        guard let data = data else {
            performCallback(.fail(.unexpected("empty response.")))
            return
        }
        performCallback(self.result(withData: data, statusCode: httpResponse.statusCode))
    }

    fileprivate func result(withData data: Data, statusCode: Int) -> Response<ResultType, OmiseGOError> {
        guard [200, 500].contains(statusCode) else {
            return .fail(.unexpected("unrecognized HTTP status code: \(statusCode)"))
        }
        do {
            let response: OmiseGOJSONResponse<ResultType> = try deserializeData(data)
            switch response.data {
            case .fail(let apiError):
                return .fail(OmiseGOError.api(apiError))
            case .success(let response):
                return .success(response)
            }
        } catch let err {
            return .fail(.other(err))
        }
    }

    fileprivate func performCallback(_ result: Response<ResultType, OmiseGOError>) {
        guard let cb = callback else { return }
        client.operationQueue.addOperation({ cb(result) })
    }

    func makeURLRequest() throws -> URLRequest? {
        guard let requestURL = endpoint.makeURL(withBaseURL: self.client.config.baseURL) else {
            throw OmiseGOError.configuration("Invalid request")
        }

        let auth = try client.encodedAuthorizationHeader()

        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        request.cachePolicy = .useProtocolCachePolicy
        request.timeoutInterval = 6.0
        request.addValue(auth, forHTTPHeaderField: "Authorization")
        request.addValue(client.contentTypeHeader(), forHTTPHeaderField: "Accept")
        request.addValue(client.contentTypeHeader(), forHTTPHeaderField: "Content-Type")

        switch endpoint.task {
        case .requestPlain:
            break
        case .requestParameters(let parameters):
            let payloadData: Data? = makePayload(for: parameters)

            guard !(request.httpMethod == "GET" && payloadData != nil) else {
                omiseGOWarn("ignoring payloads for HTTP GET operation.")
                return request
            }

            if let payload = payloadData {
                request.httpBody = payload
                request.addValue(String(payload.count), forHTTPHeaderField: "Content-Length")
            }
        }
        return request
    }

    private func makePayload(for query: APIQuery?) -> Data? {
        guard let query = query else {
            return nil
        }
        switch query {
        case let query as APIJSONQuery:
            return query.encodedPayload()
        default:
            return nil
        }
    }

}
