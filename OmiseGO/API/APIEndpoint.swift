//
//  APIEndpoint.swift
//  OmiseGO
//
//  Created by Mederic Petit on 9/10/2560 BE.
//  Copyright © 2560 OmiseGO. All rights reserved.
//

import Foundation

protocol Parametrable: Encodable {
    func encodedPayload() -> Data?
}

/// Represents an HTTP task.
enum Task {
    /// A request with no additional data.
    case requestPlain
    /// A requests body set with encoded parameters.
    case requestParameters(parameters: Parametrable)
}

enum APIEndpoint {

    case getCurrentUser
    case getBalances
    case getSettings
    case logout
    case custom(path: String, task: Task)

    var path: String {
        switch self {
        case .getCurrentUser:
            return "/user.me"
        case .getBalances:
            return "/me.list_balances"
        case .getSettings:
            return "/me.get_settings"
        case .logout:
            return "/logout"
        case .custom(let path, _):
            return path
        }
    }

    var task: Task {
        switch self {
        case .getCurrentUser, .getBalances, .getSettings, .logout: // Send no parameters
            return .requestPlain
        case .custom(_, let task):
            return task
        }
    }

    func makeURL(withBaseURL baseURL: String) -> URL? {
        guard let url = URL(string: baseURL) else {
            omiseGOWarn("Base url is not a valid URL!")
            return nil
        }
        return url.appendingPathComponent(self.path)
    }
}
