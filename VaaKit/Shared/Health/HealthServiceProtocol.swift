//
//  HealthServiceProtocol.swift
//  VaaKit
//
//  Created by Abc Abc on 3.12.2025.
//


import Foundation
import HealthKit

/// Rajapinta HealthKit-palvelulle
protocol HealthServiceProtocol {
    /// Pyytää HealthKit-luvat
    func requestAuthorization() async throws
    
    /// Lukee viimeisimmän painosamplen
    func readLatestWeightSample() async throws -> HKQuantitySample?
    
    /// Lukee viimeisimmän pituussamplen
    func readLatestHeightSample() async throws -> HKQuantitySample?
    
    /// Lukee viimeisimmän BMI-samplen
    func readLatestBMISample() async throws -> HKQuantitySample?
    
    /// Kirjoittaa painon HealthKitiin
    func writeWeight(_ value: Double) async throws
    
    /// Kirjoittaa BMI:n HealthKitiin
    func writeBMI(_ value: Double) async throws
}
