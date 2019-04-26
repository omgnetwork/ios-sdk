//
//  APIEndpoint.swift
//  OmiseGO
//
//  Created by Mederic Petit on 9/10/2017.
//  Copyright © 2017-2019 Omise Go Pte. Ltd. All rights reserved.
//

/// Protocol with the required variable to build an enpoint
protocol APIEndpoint {
    var path: String { get }
    var task: HTTPTask { get }
}
