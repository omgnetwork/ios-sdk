//
//  Response.swift
//  OmiseGO
//
//  Created by Mederic Petit on 9/10/2017.
//  Copyright © 2017-2019 Omise Go Pte. Ltd. All rights reserved.
//

/// Represents whether an API request was successfull or encountered an error.
///
/// - success: The request and post processing operations were successful resulting in the serialization
///             of the provided associated Data
/// - failure: The request encountered an error resulting in a failure
public typealias Response<Data> = Result<Data, OMGError>
