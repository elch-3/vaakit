//
//  MockHealthKitService.swift
//  VaaKit
//
//  Created by Abc Abc on 3.12.2025.
//


import Foundation
import HealthKit

final class MockHealthKitService: HealthServiceProtocol {
    
    private var weightType: HKQuantityType { .quantityType(forIdentifier: .bodyMass)! }
    private var heightType: HKQuantityType { .quantityType(forIdentifier: .height)! }
    private var bmiType: HKQuantityType { .quantityType(forIdentifier: .bodyMassIndex)! }


    var fakeWeight: HKQuantitySample?
    var fakeHeight: HKQuantitySample?
    var fakeBMI: HKQuantitySample?
    
    func requestAuthorization() async throws {
        // ei tee mitään mockissa
    }
    
    func readLatestWeightSample() async throws -> HKQuantitySample? {
        return fakeWeight
    }
    
    func readLatestHeightSample() async throws -> HKQuantitySample? {
        return fakeHeight
    }
    
    func readLatestBMISample() async throws -> HKQuantitySample? {
        return fakeBMI
    }
    
    func writeWeight(_ value: Double) async throws {
        let quantity = HKQuantity(unit: .gramUnit(with: .kilo), doubleValue: value)
        let sample = HKQuantitySample(type: weightType, quantity: quantity, start: Date(), end: Date())

        fakeWeight = sample
        // mock: voi tallentaa local variableen
    }
    
    func writeBMI(_ value: Double) async throws {
        let quantity = HKQuantity(unit: HKUnit.count(), doubleValue: value)
        let sample = HKQuantitySample(type: bmiType, quantity: quantity, start: Date(), end: Date())

        fakeBMI = sample
        // mock: voi tallentaa local variableen
    }
}
