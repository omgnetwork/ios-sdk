//
//  Response.swift
//  OmiseGO
//
//  Created by Mederic Petit on 9/10/2560 BE.
//  Copyright © 2560 OmiseGO. All rights reserved.
//

import UIKit

/// Used to represent whether an API request was successfull or encountered an error.
///
/// - success: The request and post processing operations were successful resulting in the serialization
///             of the provided associated ResultType
/// - fail: The request encountered an error resulting in a failure
public enum Response<ResultType, ErrorType> {
    case success(ResultType)
    case fail(ErrorType)
}
