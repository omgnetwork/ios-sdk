//
//  APIEndpoint.swift
//  OmiseGO
//
//  Created by Mederic Petit on 9/10/2560 BE.
//  Copyright © 2560 OmiseGO. All rights reserved.
//

import Foundation

protocol APIQuery: Encodable {}

protocol APIJSONQuery: APIQuery {
    func encodedPayload() -> Data?
}

struct APIEndpoint<DataType: OmiseGOObject> {

    let parameter: APIQuery?
    let action: String

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

    func deserialize(_ data: Data) throws -> Response<DataType, APIError> {
        let response: OmiseGOJSONResponse<DataType> = try deserializeData(data)
        return response.data
    }

}
