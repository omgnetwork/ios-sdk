//
//  FixtureClient.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 10/10/2560 BE.
//  Copyright © 2560 OmiseGO. All rights reserved.
//

import Foundation
@testable import OmiseGO

class FixtureClient: APIClient {
    let fixturesDirectoryURL: URL

    public override init(config: APIConfiguration) {
        let bundle = Bundle(for: FixtureClient.self)
        self.fixturesDirectoryURL = bundle.url(forResource: "Fixtures", withExtension: nil)!

        super.init(config: config)
    }

    @discardableResult
    override func request<ResultType>(toEndpoint endpoint: APIEndpoint<ResultType>,
                                      callback: APIRequest<ResultType>.Callback?) -> APIRequest<ResultType>? {
        do {
            let req: FixtureRequest<ResultType> = FixtureRequest(client: self, endpoint: endpoint, callback: callback)
            return try req.start()
        } catch let err as NSError {
            operationQueue.addOperation { callback?(.fail(.other(err))) }
        } catch let err as OmiseGOError {
            operationQueue.addOperation { callback?(.fail(err)) }
        }

        return nil
    }
}

class FixtureRequest<ResultType: OmiseGOObject>: APIRequest<ResultType> {
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

            defer {
                self.didComplete(data: data, error: error)
            }

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

        if let err = error {
            return performCallback(.fail(.other(err)))
        }

        guard let data = data else {
            return performCallback(.fail(.unexpected("empty response.")))
        }
        do {
            let response = try endpoint.deserialize(data)
            switch response {
            case .fail(let apiError):
                return performCallback(.fail(OmiseGOError.api(apiError)))
            case .success(let response):
                return performCallback(.success(response))
            }
        } catch let err {
            return performCallback(.fail(.other(err)))
        }
    }

    fileprivate func performCallback(_ result: Response<ResultType, OmiseGOError>) {
        guard let cb = callback else { return }
        client.operationQueue.addOperation { cb(result) }
    }
}

extension OmiseGO.APIEndpoint {
    var fixtureFilePath: String {
        let filePath = makeURL(withBaseURL: "api.omisego.co")!.absoluteString
        return (filePath + "-post" as NSString).appendingPathExtension("json")! as String
    }
}
