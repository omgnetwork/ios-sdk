//
//  OMGJSONResponse.swift
//  OmiseGO
//
//  Created by Mederic Petit on 10/10/2017 BE.
//  Copyright © 2017 OmiseGO. All rights reserved.
//

struct OMGJSONResponse<ObjectType: Decodable> {

    let version: String
    let success: Bool
    let data: Response<ObjectType>

}

extension OMGJSONResponse: Decodable {

    private enum CodingKeys: String, CodingKey {
        case version
        case success
        case data
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        version = try container.decode(String.self, forKey: .version)
        success = try container.decode(Bool.self, forKey: .success)
        if success {
            let result = try container.decode(ObjectType.self, forKey: .data)
            data = .success(data: result)
        } else {
            let error = try container.decode(APIError.self, forKey: .data)
            data = .fail(error: .api(apiError: error))
        }
    }
}
