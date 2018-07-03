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

    public func number(from string: String, subunitToUnit: BigInt) -> BigInt? {
        let decimals = Int(log10(Double(subunitToUnit)))
        return number(from: string, decimals: decimals)
    }

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

    public func string(from number: BigInt, subunitToUnit: BigInt) -> String {
        let decimals = Int(log10(Double(subunitToUnit)))
        return string(from: number, decimals: decimals)
    }

    public func string(from number: BigInt, decimals: Int) -> String {
        precondition(minFractionDigits >= 0)
        precondition(maxFractionDigits >= 0)

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
        if decimals < minFractionDigits {
            number *= BigInt(10).power(minFractionDigits - decimals)
        }
        if decimals > maxFractionDigits {
            number /= BigInt(10).power(decimals - maxFractionDigits)
        }
        var string = number.description
        if digits < decimals {
            string = String(repeating: "0", count: decimals - digits) + string
        }
        if let lastNonZeroIndex = string.reversed().index(where: { $0 != "0" })?.base {
            let numberOfZeros = string.distance(from: string.startIndex, to: lastNonZeroIndex)
            if numberOfZeros > minFractionDigits {
                let newEndIndex = string.index(string.startIndex, offsetBy: numberOfZeros - minFractionDigits)
                string = String(string[string.startIndex..<newEndIndex])
            }
        }

        return string
    }
}
