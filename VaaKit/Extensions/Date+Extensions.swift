//
//  Date+Extensions.swift
//  VaaKit
//
//  Created by Abc Abc on 4.12.2025.
//

import Foundation

extension Date {
    func formattedFinnish() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "fi_FI")
        formatter.dateFormat = "d.M.yyyy"
        return formatter.string(from: self)
    }
}
