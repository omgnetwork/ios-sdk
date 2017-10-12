//
//  APIEndpoint.swift
//  OmiseGO
//
//  Created by Mederic Petit on 9/10/2560 BE.
//  Copyright © 2560 OmiseGO. All rights reserved.
//

import Foundation

public protocol APIQuery: Encodable {}

public protocol APIURLQuery: APIQuery {}

public protocol APIJSONQuery: APIURLQuery {}

public struct APIEndpoint<DataType: OmiseGOObject> {

    public typealias Result = DataType

    public let parameter: APIQuery?
    public let action: String

    init(action: String, parameter: APIQuery? = nil) {
        self.action = action
        self.parameter = parameter
    }

    func makeURL(withBaseURL baseURL: String) -> URL? {
        guard let url = URL(string: baseURL) else {
            omiseGOWarn("Base url is not a valid URL!")
            return nil
        }
        return url.appendingPathComponent(self.action)
    }

    func deserialize(_ data: Data) throws -> Failable<DataType, APIError> {
        let response: OmiseGOJSONResponse<DataType> = try deserializeData(data)
        return response.data
    }

}
