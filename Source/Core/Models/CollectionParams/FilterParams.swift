//
//  SearchParams.swift
//  OmiseGO
//
//  Created by Mederic Petit on 17/9/18.
//  Copyright © 2017-2019 Omise Go Pte. Ltd. All rights reserved.
//

import BigInt

/// A type that represents a filterable ressource
public protocol Filterable {
    associatedtype FilterableFields: RawEnumerable where FilterableFields.RawValue == String
}

/// A comparator for boolean value
///
/// - equal: The value must match exactly fhe field
/// - notEqual: The value must be different from the field
///
/// Note: equal with a true value is the same as notEqual with a false value
public enum BooleanFilterComparator: String, Encodable {
    case equal = "eq"
    case notEqual = "neq"
}

/// A comparator for string values
///
/// - equal: The value must match exactly fhe field
/// - notEqual: The value must be different from the field
/// - contains: The value must be a substring of the field
/// - startsWith: The field must start with the value
public enum StringFilterComparator: String, Encodable {
    case equal = "eq"
    case notEqual = "neq"
    case contains
    case startsWith = "starts_with"
}

/// A comparator for numeric values (BigInts)
///
/// - equal: The value must match exactly the field
/// - notEqual: The value must be different from the field
/// - lessThan: The value must be inferior to the field
/// - lessThanOrEqual: The value must be inferior or equal to the field
/// - greaterThan: The value must be superior to the field
/// - greaterThanOrEqual: The value must me superior or equal to the field
public enum NumericFilterComparator: String, Encodable {
    case equal = "eq"
    case notEqual = "neq"
    case lessThan = "lt"
    case lessThanOrEqual = "lte"
    case greaterThan = "gt"
    case greaterThanOrEqual = "gte"
}

/// A comparator for nil values
///
/// - nil: The value must be nil
/// - notNil: The value must not be nil
public enum NilComparator: String, Encodable {
    case `nil` = "eq"
    case notNil = "neq"
}

/// Represents a filter that can be used in filtrable queries
public struct Filter<F: Filterable>: APIParameters {
    var field: String
    var comparator: String
    var value: Any?

    enum CodingKeys: String, CodingKey {
        case field
        case comparator
        case value
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(field, forKey: .field)
        try container.encode(comparator, forKey: .comparator)
        switch self.value {
        case .none: try container.encodeNil(forKey: .value)
        case let value as String: try container.encode(value, forKey: .value)
        case let value as Bool: try container.encode(value, forKey: .value)
        case let value as BigInt: try container.encode(value, forKey: .value)
        default:
            throw OMGError.unexpected(message: "Unexepected value type for filter")
        }
    }
}

extension Filterable {
    /// Initialize a new Filter object with a String value
    ///
    /// - Parameters:
    ///   - field: The field to filter
    ///   - comparator: The String comparator to use
    ///   - value: The value to use to filter
    /// - Returns: A Filter object initialized with the specified properties
    public static func filter(field: FilterableFields, comparator: StringFilterComparator, value: String) -> Filter<Self> {
        return Filter(field: field.rawValue, comparator: comparator.rawValue, value: value)
    }

    /// Initialize a new Filter object with a Bool value
    ///
    /// - Parameters:
    ///   - field: The field to filter
    ///   - comparator: The Boolean comparator to use
    ///   - value: The value to use to filter
    /// - Returns: A Filter object initialized with the specified properties
    public static func filter(field: FilterableFields, comparator: BooleanFilterComparator, value: Bool) -> Filter<Self> {
        return Filter(field: field.rawValue, comparator: comparator.rawValue, value: value)
    }

    /// Initialize a new Filter object with a BigInt value
    ///
    /// - Parameters:
    ///   - field: The field to filter
    ///   - comparator: The Numeric comparator to use
    ///   - value: The value to use to filter
    /// - Returns: A Filter object initialized with the specified properties
    public static func filter(field: FilterableFields, comparator: NumericFilterComparator, value: BigInt) -> Filter<Self> {
        return Filter(field: field.rawValue, comparator: comparator.rawValue, value: value)
    }

    /// Initialize a new Filter object for a nil comparison
    ///
    /// - Parameters:
    ///   - field: The field to filter
    ///   - comparator: The Nil comparator to use
    /// - Returns: A Filter object initialized with the specified properties
    public static func filter(field: FilterableFields, comparator: NilComparator) -> Filter<Self> {
        return Filter(field: field.rawValue, comparator: comparator.rawValue, value: nil)
    }

    /// Initialize an advanced new Filter object with a String value
    ///
    /// - Parameters:
    ///   - field: The field to filter. Can contain nested relations snake_cased.
    ///   - comparator: The String comparator to use
    ///   - value: The value to use to filter
    /// - Returns: A Filter object initialized with the specified properties
    public static func filter(field: String, comparator: StringFilterComparator, value: String?) -> Filter<Self> {
        return Filter(field: field, comparator: comparator.rawValue, value: value)
    }

    /// Initialize an advanced new Filter object with a Bool value
    ///
    /// - Parameters:
    ///   - field: The field to filter. Can contain nested relations snake_cased.
    ///   - comparator: The Boolean comparator to use
    ///   - value: The value to use to filter
    /// - Returns: A Filter object initialized with the specified properties
    public static func filter(field: String, comparator: BooleanFilterComparator, value: Bool) -> Filter<Self> {
        return Filter(field: field, comparator: comparator.rawValue, value: value)
    }

    /// Initialize an advanced new Filter object with a BigInt value
    ///
    /// - Parameters:
    ///   - field: The field to filter. Can contain nested relations snake_cased.
    ///   - comparator: The Numeric comparator to use
    ///   - value: The value to use to filter
    /// - Returns: A Filter object initialized with the specified properties
    public static func filter(field: String, comparator: NumericFilterComparator, value: BigInt?) -> Filter<Self> {
        return Filter(field: field, comparator: comparator.rawValue, value: value)
    }

    /// Initialize a new Filter object for a nil comparison
    ///
    /// - Parameters:
    ///   - field: The field to filter. Can contain nested relations snake_cased.
    ///   - comparator: The Nil comparator to use
    /// - Returns: A Filter object initialized with the specified properties
    public static func filter(field: String, comparator: NilComparator) -> Filter<Self> {
        return Filter(field: field, comparator: comparator.rawValue, value: nil)
    }
}

public struct FilterParams<F: Filterable>: APIParameters {
    let matchAll: [Filter<F>]?
    let matchAny: [Filter<F>]?

    public init(matchAll: [Filter<F>]? = nil, matchAny: [Filter<F>]? = nil) {
        self.matchAll = matchAll
        self.matchAny = matchAny
    }

    enum CodingKeys: String, CodingKey {
        case matchAll = "match_all"
        case matchAny = "match_any"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(matchAll, forKey: .matchAll)
        try container.encodeIfPresent(matchAny, forKey: .matchAny)
    }
}
