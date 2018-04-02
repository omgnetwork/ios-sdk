//
//  RequestBuilder.swift
//  OmiseGO
//
//  Created by Mederic Petit on 16/3/18.
//

import UIKit

class RequestBuilder {

    private let requestParameters: RequestParameters

    init(requestParameters: RequestParameters) {
        self.requestParameters = requestParameters
    }

    func buildHTTPURLRequest(withEndpoint endpoint: APIEndpoint) throws -> URLRequest {
        guard let requestURL = endpoint.makeURL(withBaseURL: self.requestParameters.baseURL()) else {
            throw OMGError.configuration(message: "Invalid request")
        }
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        request.cachePolicy = .useProtocolCachePolicy
        request.timeoutInterval = 6.0
        try self.addRequiredHeaders(toRequest: &request)
        endpoint.additionalHeaders?.forEach({ (key, value) in
            request.addValue(value, forHTTPHeaderField: key)
        })

        switch endpoint.task {
        case .requestPlain: break
        case .requestParameters(let parameters):
            let payload: Data = try parameters.encodedPayload()
            request.httpBody = payload
            request.addValue(String(payload.count), forHTTPHeaderField: "Content-Length")
        }
        return request
    }

    func buildWebsocketRequest() throws -> URLRequest {
        let requestURL = URL(string: self.requestParameters.baseURL())!
        var request = URLRequest(url: requestURL)
        request.timeoutInterval = 6.0
        try self.addRequiredHeaders(toRequest: &request)
        return request
    }

    private func addRequiredHeaders(toRequest request: inout URLRequest) throws {
        let auth = try self.requestParameters.encodedAuthorizationHeader()
        request.addValue(auth, forHTTPHeaderField: "Authorization")
        request.addValue(self.requestParameters.acceptHeader(), forHTTPHeaderField: "Accept")
        request.addValue(self.requestParameters.contentTypeHeader(), forHTTPHeaderField: "Content-Type")
    }

}
