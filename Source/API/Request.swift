//
//  Request.swift
//  OmiseGO
//
//  Created by Mederic Petit on 9/10/2017.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

/// Represents a cancellable request
public class Request<ResultType: Decodable> {

    public typealias Callback = (Response<ResultType>) -> Void

    let client: HTTPClient
    let endpoint: APIEndpoint
    let callback: Request.Callback?

    var task: URLSessionTask?

    init(client: HTTPClient, endpoint: APIEndpoint, callback: Callback?) {
        self.client = client
        self.endpoint = endpoint
        self.callback = callback
    }

    /// Cancel the request
    public func cancel() {
        task?.cancel()
    }

    func start() throws -> Self {
        let urlRequest = try RequestBuilder.init(requestParameters: RequestParameters(config: self.client.config))
            .buildHTTPURLRequest(withEndpoint: self.endpoint)
        let dataTask = client.session.dataTask(with: urlRequest, completionHandler: didComplete)
        self.task = dataTask
        dataTask.resume()

        return self
    }

    private func didComplete(_ data: Data?, response: URLResponse?, error: Error?) {
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

    private func result(withData data: Data, statusCode: Int) -> Response<ResultType> {
        guard [200, 500].contains(statusCode) else {
            return .fail(error: .unexpected(message: "unrecognized HTTP status code: \(statusCode)"))
        }
        do {
            let response: JSONResponse<ResultType> = try deserializeData(data)
            return response.data
        } catch let error {
            return .fail(error: .other(error: error))
        }
    }

    private func performCallback(_ result: Response<ResultType>) {
        guard let cb = callback else { return }
        OperationQueue.main.addOperation({ cb(result) })
    }

}
