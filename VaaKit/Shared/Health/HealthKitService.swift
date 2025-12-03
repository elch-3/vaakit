//
//  HealthKitService.swift
//  VaaKit
//
//  Created by Abc Abc on 3.12.2025.
//


import Foundation
import HealthKit

final class HealthKitService: HealthServiceProtocol {

    private var weightType: HKQuantityType { .quantityType(forIdentifier: .bodyMass)! }
    private var heightType: HKQuantityType { .quantityType(forIdentifier: .height)! }
    private var bmiType: HKQuantityType { .quantityType(forIdentifier: .bodyMassIndex)! }

    private let store: HKHealthStore

    // ✅ Tuotantokonstruktori
    init() {
        self.store = HKHealthStore()
    }
    
    // ✅ Testikonstruktori: injektoi halutun store:n (simulaattori / mock)
    init(store: HKHealthStore) {
        self.store = store
    }
    
    // MARK: - Authorization
    func requestAuthorization() async throws {
        let toRead: Set = [weightType, heightType, bmiType]
        let toWrite: Set = [weightType, bmiType] // height yleensä ei kirjoiteta
        try await store.requestAuthorization(toShare: toWrite, read: toRead)
    }
    
    // MARK: - Read latest sample
    func readLatestWeightSample() async throws -> HKQuantitySample? {
        try await readLatestSample(type: weightType)
    }
    
    func readLatestHeightSample() async throws -> HKQuantitySample? {
        try await readLatestSample(type: heightType)
    }
    
    func readLatestBMISample() async throws -> HKQuantitySample? {
        try await readLatestSample(type: bmiType)
    }
    
    // MARK: - Write
    func writeWeight(_ value: Double) async throws {
        let quantity = HKQuantity(unit: .gramUnit(with: .kilo), doubleValue: value)
        let sample = HKQuantitySample(type: weightType, quantity: quantity, start: Date(), end: Date())
        try await store.save(sample)
    }
    
    func writeBMI(_ value: Double) async throws {
        let quantity = HKQuantity(unit: HKUnit.count(), doubleValue: value)
        let sample = HKQuantitySample(type: bmiType, quantity: quantity, start: Date(), end: Date())
        try await store.save(sample)
    }
    
    // MARK: - Helper
    private func readLatestSample(type: HKQuantityType) async throws -> HKQuantitySample? {
        return try await withCheckedThrowingContinuation { continuation in
            let sort = NSSortDescriptor(key: HKSampleSortIdentifierStartDate, ascending: false)
            let query = HKSampleQuery(
                sampleType: type,
                predicate: nil,
                limit: 1,
                sortDescriptors: [sort]
            ) { _, samples, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }
                let sample = samples?.first as? HKQuantitySample
                continuation.resume(returning: sample) // palauttaa HKQuantitySample
            }
            store.execute(query)
        }
    }
}
