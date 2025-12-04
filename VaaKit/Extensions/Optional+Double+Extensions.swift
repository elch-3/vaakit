//
//  Optional+Double+Extensions.swift
//  VaaKit
//
//  Created by Abc Abc on 4.12.2025.
//

import Foundation

extension Optional where Wrapped == Double {
    func formatted(_ decimals: Int = 1) -> String {
        switch self {
        case .some(let value):
            return String(format: "%.\(decimals)f", value)
        case .none:
            return "-"
        }
    }
}
