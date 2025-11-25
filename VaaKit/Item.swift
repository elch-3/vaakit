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
    var height: Double  // pituus metreinä
    var weight: Double  // paino kg
    var bmi: Double     // painoindeksi

    init(timestamp: Date = Date(), height: Double = 0.0, weight: Double = 0.0, bmi: Double = 0.0) {
        self.timestamp = timestamp
        self.height = height
        self.weight = weight
        self.bmi = bmi
    }
}
