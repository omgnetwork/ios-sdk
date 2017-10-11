//
//  APIRequest.swift
//  OmiseGO
//
//  Created by Mederic Petit on 9/10/2560 BE.
//  Copyright © 2560 OmiseGO. All rights reserved.
//

import Foundation

public class APIRequest<ResultType: OmiseGOObject> {
    public typealias Endpoint = APIEndpoint<ResultType>
    public typealias Callback = (Failable<ResultType, OmiseGOError>) -> Void

    let client: APIClient
    let endpoint: APIRequest.Endpoint
    let callback: APIRequest.Callback?

    var task: URLSessionTask?

    init(client: APIClient, endpoint: Endpoint, callback: Callback?) {
        self.client = client
        self.endpoint = endpoint
        self.callback = callback
    }

    public func cancel() {
        task?.cancel()
    }

    func start() throws -> Self {
        let urlRequest = try makeURLRequest()
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

    fileprivate func result(withData data: Data, statusCode: Int) -> Failable<ResultType, OmiseGOError> {
        guard ![200, 500].contains(statusCode) else {
            return .fail(.unexpected("unrecognized HTTP status code: \(statusCode)"))
        }
        do {
            let response = try endpoint.deserialize(data)
            switch response {
            case .fail(let apiError):
                return Failable.fail(OmiseGOError.api(apiError))
            case .success(let response):
                return Failable.success(response)
            }
        } catch let err {
            return .fail(.other(err))
        }
    }

    fileprivate func performCallback(_ result: Failable<ResultType, OmiseGOError>) {
        guard let cb = callback else { return }
        client.operationQueue.addOperation({ cb(result) })
    }

    func makeURLRequest() throws -> URLRequest {
        let requestURL = endpoint.makeURL()

        let auth = try client.encodedAuthorizationHeader()

        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        request.cachePolicy = .useProtocolCachePolicy
        request.timeoutInterval = 6.0
        request.addValue(auth, forHTTPHeaderField: "Authorization")
        request.addValue(client.contentTypeHeader(), forHTTPHeaderField: "Accept")
        request.addValue(client.contentTypeHeader(), forHTTPHeaderField: "Content-Type")

        let payloadData: Data? = makePayload(for: endpoint.parameter)

        guard !(request.httpMethod == "GET" && payloadData != nil) else {
            omiseGOWarn("ignoring payloads for HTTP GET operation.")
            return request as URLRequest
        }

        if let payload = payloadData {
            request.httpBody = payload
            request.addValue(String(payload.count), forHTTPHeaderField: "Content-Length")
        }

        return request as URLRequest
    }

    private func makePayload(for query: APIQuery?) -> Data? {
        guard let query = query else {
            return nil
        }
        switch query {
        case let query as APIURLQuery:
            return makePayload(for: query)
        default:
            return nil
        }
    }

    private func makePayload(for query: APIURLQuery?) -> Data? {
        var urlComponents = URLComponents()
        let encoder = URLQueryItemEncoder()
        encoder.arrayIndexEncodingStrategy = .emptySquareBrackets
        urlComponents.queryItems = try? encoder.encode(query)
        return urlComponents.percentEncodedQuery?.data(using: .utf8)
    }
}
