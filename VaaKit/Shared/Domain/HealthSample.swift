//
//  HealthSample.swift
//  VaaKit
//
//  Created by Abc Abc on 3.12.2025.
//


import Foundation
import HealthKit

enum HealthSampleType {
    case weight
    case height
    case bmi
}

/// Sovellus-layerin domain-objekti
struct HealthSample {
    let type: HealthSampleType 
    let value: Double         // Numeroarvo (kg, cm, jne.)
    let date: Date            // Sample start date
    let sourceRevision: HKSourceRevision
    let rawSample: HKQuantitySample // Alkuperäinen HealthKit-sample, sisältää esim. device, metadata, unit jne.
}
