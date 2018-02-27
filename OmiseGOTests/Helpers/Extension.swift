//
//  Extension.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 23/2/18.
//  Copyright © 2018 OmiseGO. All rights reserved.
//

import UIKit

extension String {

    func toDate(withFormat format: String? = "yyyy-MM-dd'T'HH:mm:ssZ") -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.date(from: self)!
    }

}
