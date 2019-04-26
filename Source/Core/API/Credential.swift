//
//  Credential.swift
//  OmiseGO
//
//  Created by Mederic Petit on 6/8/18.
//  Copyright © 2017-2019 Omise Go Pte. Ltd. All rights reserved.
//

/// Contains the required functions that a configuration object would need to authenticate an API call if needed
protocol Credential {
    func isAuthenticated() -> Bool
    func authentication() throws -> String?
    mutating func update(withAuthenticationToken authenticationToken: AuthenticationToken)
    mutating func invalidate()
}
