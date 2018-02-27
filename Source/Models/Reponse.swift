//
//  Response.swift
//  OmiseGO
//
//  Created by Mederic Petit on 9/10/2017 BE.
//  Copyright © 2017 OmiseGO. All rights reserved.
//

/// Used to represent whether an API request was successfull or encountered an error.
///
/// - success: The request and post processing operations were successful resulting in the serialization
///             of the provided associated Data
/// - fail: The request encountered an error resulting in a failure
public enum Response<Data> {
    case success(data: Data)
    case fail(error: OmiseGOError)
}
