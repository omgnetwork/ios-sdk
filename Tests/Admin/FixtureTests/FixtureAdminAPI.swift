//
//  FixtureAdminAPI.swift
//  Tests
//
//  Created by Mederic Petit on 14/9/18.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

@testable import OmiseGO

class FixtureAdminAPI: HTTPAdminAPI {
    let fixturesDirectoryURL: URL

    init(fixturesDirectoryURL: URL, config: AdminConfiguration) {
        self.fixturesDirectoryURL = fixturesDirectoryURL
        super.init(config: config)
    }

    @discardableResult
    override func request<ResultType>(toEndpoint endpoint: APIEndpoint,
                                      callback: Request<ResultType>.Callback?) -> Request<ResultType>? {
        do {
            let request: FixtureRequest<ResultType> = FixtureRequest(fixturesDirectoryURL: self.fixturesDirectoryURL,
                                                                     client: self,
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
