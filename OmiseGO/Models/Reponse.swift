//
//  Response.swift
//  OmiseGO
//
//  Created by Mederic Petit on 9/10/2560 BE.
//  Copyright © 2560 OmiseGO. All rights reserved.
//

import UIKit

public enum Response<ResultType, ErrorType> {
    case success(ResultType)
    case fail(ErrorType)
}
