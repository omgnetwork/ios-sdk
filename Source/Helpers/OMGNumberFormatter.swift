//
//  OMGNumberFormatter.swift
//  OmiseGO
//
//  Created by Mederic Petit on 15/6/18.
//  Copyright © 2017-2018 Omise Go Pte. Ltd. All rights reserved.
//

import BigInt

public final class OMGNumberFormatter {
    var minFractionDigits = 0
    var maxFractionDigits = Int.max
    var decimalSeparator = "."
    var groupingSeparator = ","

    public init(locale: Locale = .current, precision: Int = Int.max) {
        self.decimalSeparator = locale.decimalSeparator ?? "."
        self.groupingSeparator = locale.groupingSeparator ?? ","
        self.maxFractionDigits = precision
    }

    /// Create a BigInt number given a string number and a subunitToUnit
    ///
    /// - Parameters:
    ///   - string: The string number to process. If invalid, this function returns nil.
    ///   - subunitToUnit: The subunit to unit to be used to generate the number.
    /// - Returns: A formatted BigInt number.
    /// - ie: Given string: 13.37 and subunitToUnit: 100 will return a number equivalent to 1337.
    public func number(from string: String, subunitToUnit: BigInt) -> BigInt? {
        let decimals = Int(log10(Double(subunitToUnit)))
        return self.number(from: string, decimals: decimals)
    }

    /// Create a BigInt number given a string number and a decimal count
    ///
    /// - Parameters:
    ///   - string: The string number to process. If invalid, this function returns nil.
    ///   - decimals: The amount of decimal of the number
    /// - Returns: A formatted BigInt number.
    /// - ie: Given string: 13.37 and decimals: 2 will return a number equivalent to 1337.
    public func number(from string: String, decimals: Int) -> BigInt? {
        guard string != "" else { return nil }
        guard let index = string.index(where: { String($0) == decimalSeparator }) else {
            return BigInt(string).flatMap({ $0 * BigInt(10).power(decimals) })
        }
        let nonFractionalDigits = string.distance(from: string.startIndex, to: index)
        let fractionalDigits = string.distance(from: string.index(after: index), to: string.endIndex)

        var fullString = string
        fullString.remove(at: index)

        if fractionalDigits > decimals {
            fullString = String(fullString.prefix(nonFractionalDigits + decimals))
        }

        guard let number = BigInt(fullString) else { return nil }

        if fractionalDigits < decimals {
            return number * BigInt(10).power(decimals - fractionalDigits)
        } else {
            return number
        }
    }

    /// Generate a string representation of the given number and subunit to unit.
    ///
    /// - Parameters:
    ///   - number: The BigInt number to format
    ///   - subunitToUnit: The subunit to unit of the number
    /// - Returns: A string representation of the number.
    /// - ie: Given number: BigInt(1337) and subunitToUnit: 100 will return the string: "13.37"
    public func string(from number: BigInt, subunitToUnit: BigInt) -> String {
        let decimals = Int(log10(Double(subunitToUnit)))
        return self.string(from: number, decimals: decimals)
    }

    /// Generate a string representation of the given number and decimal count
    ///
    /// - Parameters:
    ///   - number: The BigInt number to format
    ///   - decimals: The amount of decimals of the number
    /// - Returns: A string representation of the number.
    /// - ie: Given number: BigInt(1337) and subunitToUnit: 100 will return the string: "13.37"
    public func string(from number: BigInt, decimals: Int) -> String {
        precondition(self.minFractionDigits >= 0)
        precondition(self.maxFractionDigits >= 0)

        let dividend = BigInt(10).power(decimals)
        let (integerPart, remainder) = number.quotientAndRemainder(dividingBy: dividend)
        let integerString = self.integerString(from: integerPart)
        let fractionalString = self.fractionalString(from: BigInt(sign: .plus, magnitude: remainder.magnitude), decimals: decimals)
        if fractionalString.isEmpty {
            return integerString
        }
        return "\(integerString).\(fractionalString)"
    }

    private func integerString(from: BigInt) -> String {
        var string = from.description
        let end = from.sign == .minus ? 1 : 0
        for offset in stride(from: string.count - 3, to: end, by: -3) {
            let index = string.index(string.startIndex, offsetBy: offset)
            string.insert(contentsOf: groupingSeparator, at: index)
        }
        return string
    }

    private func fractionalString(from number: BigInt, decimals: Int) -> String {
        var number = number
        let digits = number.description.count

        if number == 0 || decimals - digits >= self.maxFractionDigits {
            return String(repeating: "0", count: self.minFractionDigits)
        }
        if decimals < self.minFractionDigits {
            number *= BigInt(10).power(self.minFractionDigits - decimals)
        }
        if decimals > self.maxFractionDigits {
            number /= BigInt(10).power(decimals - self.maxFractionDigits)
        }
        var string = number.description
        if digits < decimals {
            string = String(repeating: "0", count: decimals - digits) + string
        }
        if let lastNonZeroIndex = string.reversed().index(where: { $0 != "0" })?.base {
            let numberOfZeros = string.distance(from: string.startIndex, to: lastNonZeroIndex)
            if numberOfZeros > self.minFractionDigits {
                let newEndIndex = string.index(string.startIndex, offsetBy: numberOfZeros - minFractionDigits)
                string = String(string[string.startIndex ..< newEndIndex])
            }
        }

        return string
    }
}
