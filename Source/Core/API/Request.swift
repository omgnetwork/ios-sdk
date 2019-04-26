//
//  Request.swift
//  OmiseGO
//
//  Created by Mederic Petit on 9/10/2017.
//  Copyright © 2017-2019 Omise Go Pte. Ltd. All rights reserved.
//

/// Represents a cancellable request
public class Request<ResultType: Decodable> {
    public typealias Callback = (Response<ResultType>) -> Void

    let client: HTTPAPI
    let endpoint: APIEndpoint
    let callback: Request.Callback?

    var task: URLSessionTask?

    init(client: HTTPAPI, endpoint: APIEndpoint, callback: Callback?) {
        self.client = client
        self.endpoint = endpoint
        self.callback = callback
    }

    /// Cancel the request
    public func cancel() {
        self.task?.cancel()
    }

    func start() throws -> Self {
        let urlRequest = try RequestBuilder(configuration: self.client.config).buildHTTPURLRequest(withEndpoint: self.endpoint)
        let dataTask = client.session.dataTask(with: urlRequest, completionHandler: didComplete)
        self.task = dataTask
        dataTask.resume()

        return self
    }

    private func didComplete(_ data: Data?, response: URLResponse?, error: Error?) {
        // no one's in the forest to hear the leaf falls.
        guard self.callback != nil else { return }

        if let error = error {
            self.performCallback(.failure(.other(error: error)))
            return
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            self.performCallback(.failure(.unexpected(message: "no error and no response.")))
            return
        }

        guard let data = data else {
            self.performCallback(.failure(.unexpected(message: "empty response.")))
            return
        }
        self.performCallback(self.result(withData: data, statusCode: httpResponse.statusCode))
    }

    func result(withData data: Data, statusCode: Int) -> Response<ResultType> {
        guard [200, 500].contains(statusCode) else {
            return .failure(.unexpected(message: "unrecognized HTTP status code: \(statusCode)"))
        }
        do {
            if self.client.config.debugLog {
                omiseGOInfo("Did receive: \(String(data: data, encoding: .utf8) ?? "")")
            }
            let response: JSONResponse<ResultType> = try deserializeData(data)
            return response.data
        } catch let error as DecodingError {
            return .failure(.decoding(underlyingError: error))
        } catch {
            return .failure(.other(error: error))
        }
    }

    func performCallback(_ result: Response<ResultType>) {
        guard let cb = callback else { return }
        OperationQueue.main.addOperation { cb(result) }
    }
}
