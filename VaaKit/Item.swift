//
//  Item.swift
//  VaaKit
//
//  Created by Abc Abc on 25.11.2025.
//


import Foundation
import SwiftData

@Model
class Item {
    var timestamp: Date
    var paino: String
    var field2: String

    init(timestamp: Date, _paino: String = "", field2: String = "") {
        self.timestamp = timestamp
        self.paino = _paino
        self.field2 = field2
    }
}
