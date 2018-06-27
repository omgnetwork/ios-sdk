//
//  FixtureClient.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 10/10/2017.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

import Foundation
@testable import OmiseGO

class FixtureClient: HTTPClient {
    let fixturesDirectoryURL: URL

    public override init(config: ClientConfiguration) {
        let bundle = Bundle(for: FixtureClient.self)
        self.fixturesDirectoryURL = bundle.url(forResource: "Fixtures", withExtension: nil)!

        super.init(config: config)
    }

    @discardableResult
    override func request<ResultType>(toEndpoint endpoint: APIEndpoint,
                                      callback: Request<ResultType>.Callback?) -> Request<ResultType>? {
        do {
            let request: FixtureRequest<ResultType> = FixtureRequest(client: self,
                                                                     endpoint: endpoint,
                                                                     callback: callback)
            return try request.start()
        } catch let error as NSError {
            operationQueue.addOperation { callback?(.fail(error: .other(error: error))) }
        } catch let error as OMGError {
            operationQueue.addOperation { callback?(.fail(error: error)) }
        }

        return nil
    }
}

class FixtureRequest<ResultType: Decodable>: Request<ResultType> {
    var fixtureClient: FixtureClient? {
        return client as? FixtureClient
    }

    override func start() throws -> Self {
        guard let client = self.client as? FixtureClient else {
            return self
        }
        let fixtureFilePath = endpoint.fixtureFilePath
        let fixtureFileURL = client.fixturesDirectoryURL.appendingPathComponent(fixtureFilePath)
        DispatchQueue.global().async {
            let data: Data?
            let error: Error?
            defer { self.didComplete(data: data, error: error) }
            do {
                data = try Data(contentsOf: fixtureFileURL)
                error = nil
            } catch let thrownError {
                data = nil
                error = thrownError
            }
        }
        return self
    }

    fileprivate func didComplete(data: Data?, error: Error?) {
        guard callback != nil else { return }

        if let error = error {
            return performCallback(.fail(error: .other(error: error)))
        }

        guard let data = data else {
            return performCallback(.fail(error: .unexpected(message: "empty response.")))
        }
        performCallback(self.result(withData: data, statusCode: 200))
    }
}

extension OmiseGO.APIEndpoint {
    var fixtureFilePath: String {
        let filePath = URL(string: "fixture")!.appendingPathComponent(path).absoluteString
        return (filePath as NSString).appendingPathExtension("json")! as String
    }
}
