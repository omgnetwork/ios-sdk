//
//  APIAdminEndpoint.swift
//  OmiseGO
//
//  Created by Mederic Petit on 9/10/2017.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

/// Represents an admin api endpoint.
enum APIAdminEndpoint: APIEndpoint {
    var path: String {
        return ""
    }

    var task: HTTPTask {
        return .requestPlain
    }
}
