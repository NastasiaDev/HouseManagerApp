//
//  PhoneValidator.swift
//  HouseManagerApp
//
//  Created by Anastasia Larina on 06.02.2025.
//

import Foundation

final class PhoneValidator  {
    static func validatePhoneNumber(_ number: String) -> Bool {
        let pattern = "^\\+7 \\d{3} \\d{3}-\\d{2}-\\d{2}$"
        let regex = try! NSRegularExpression(pattern: pattern)
        let range = NSRange(location: 0, length: number.utf16.count)
        return regex.firstMatch(in: number, options: [], range: range) != nil
    }

    static func formatPhoneNumber(_ number: String) -> String {
        var digits = number.filter { "0123456789".contains($0) }
        if !digits.hasPrefix("7") {
            digits = "7" + digits
        }
        digits = String(digits.prefix(11))

        var formatted = "+7 "
        let sections = [3, 3, 2, 2]
        var index = digits.index(after: digits.startIndex)

        for (i, section) in sections.enumerated() {
            let end = digits.index(index, offsetBy: section, limitedBy: digits.endIndex) ?? digits.endIndex
            if index < end {
                formatted += String(digits[index ..< end])
                if i == 0 {
                    formatted += " "
                } else if i == 1 || i == 2 {
                    formatted += "-"
                }
            }
            index = end
        }
        return formatted
    }
}
