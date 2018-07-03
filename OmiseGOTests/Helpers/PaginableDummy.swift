//
//  SortableDummy.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 23/2/18.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

import OmiseGO

struct SortableDummy: Paginable {
    let aSortableAttribute: String
    let aNonSortableAttribute: String

    let aSearchableAttribute: String
    let aNonSearchableAttribute: String

    enum SortableFields: String, KeyEncodable {
        case aSortableAttribute = "a_sortable_attribute"
    }

    enum SearchableFields: String, KeyEncodable {
        case aSearchableAttribute = "a_searchable_attribute"
    }
}
