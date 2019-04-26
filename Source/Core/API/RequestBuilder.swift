//
//  RequestBuilder.swift
//  OmiseGO
//
//  Created by Mederic Petit on 16/3/18.
//

import UIKit

final class RequestBuilder {
    private let configuration: Configuration

    init(configuration: Configuration) {
        self.configuration = configuration
    }

    func buildHTTPURLRequest(withEndpoint endpoint: APIEndpoint) throws -> URLRequest {
        guard let requestURL = URL(string: self.configuration.baseAPIURL)?.appendingPathComponent(endpoint.path) else {
            throw OMGError.configuration(message: "Invalid base url")
        }

        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        request.cachePolicy = .useProtocolCachePolicy
        request.timeoutInterval = 6.0

        try addRequiredHeaders(toRequest: &request)

        // Add endpoint's task parameters if necessary
        if let parameters = endpoint.task.parameters {
            let payload = try parameters.encodedPayload()
            request.httpBody = payload
            request.addValue(String(payload.count), forHTTPHeaderField: "Content-Length")
        }

        return request
    }

    func buildWebsocketRequest() throws -> URLRequest {
        guard let url = URL(string: self.configuration.baseAPIURL + "/socket") else {
            throw OMGError.configuration(message: "Invalid base url")
        }

        var request = URLRequest(url: url)
        request.timeoutInterval = 6.0
        try addRequiredHeaders(toRequest: &request)
        return request
    }

    func contentTypeHeader() -> String {
        return "application/vnd.omisego.v\(self.configuration.apiVersion)+json; charset=utf-8"
    }

    func acceptHeader() -> String {
        return "application/vnd.omisego.v\(self.configuration.apiVersion)+json"
    }

    private func addRequiredHeaders(toRequest request: inout URLRequest) throws {
        if let auth = try self.configuration.credentials.authentication() {
            request.addValue(auth, forHTTPHeaderField: "Authorization")
        }
        request.addValue(self.acceptHeader(), forHTTPHeaderField: "Accept")
        request.addValue(self.contentTypeHeader(), forHTTPHeaderField: "Content-Type")
    }
}
