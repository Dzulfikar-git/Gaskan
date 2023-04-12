//
//  TextFieldUtil.swift
//  Gaskan
//
//  Created by Dzulfikar on 05/04/23.
//

import Foundation

// This struct is used to contains utils function for TextField
struct TextFieldUtil {
    
    // This function is used to handle duplicate decimal. It will match the decimal pattern of `.`
    // If match count >= 1, then it will drop the new decimal input.
    static func handleDecimalInput(value: String) -> String {
        let pattern = "\\.(?=.*\\.)"
        let regex = try! NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        let matches = regex.matches(in: value, options: [], range: NSRange(location: 0, length: value.utf16.count))
        if matches.count >= 1 {
            // input value has more than 1 decimal place
            return String(value.dropLast())
        }
        return String(value)
    }
}
