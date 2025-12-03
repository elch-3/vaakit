//
//  HealthRepository.swift
//  VaaKit
//
//  Created by Abc Abc on 3.12.2025.
//


import Foundation
import HealthKit

final class HealthRepository : ObservableObject {
    
    private let service: HealthServiceProtocol
    
    init(service: HealthServiceProtocol) {
        self.service = service
    }
    
    func requestAuthorization() async throws {
        try await service.requestAuthorization()
    }
    /// Lukee viimeisimmän painon ja muuntaa HealthSampleksi
    func getLatestWeight() async throws -> HealthSample? {
        guard let sample = try await service.readLatestWeightSample() else { return nil }
        let value = sample.quantity.doubleValue(for: .gramUnit(with: .kilo))
        let startDate = sample.startDate
        let sourceRevision = sample.sourceRevision
        return HealthSample(
            type: .weight,
            value: value,
            date: sample.startDate,
            sourceRevision: sample.sourceRevision,
            rawSample: sample
        )
    }
    
    /// Lukee viimeisimmän pituuden ja muuntaa HealthSampleksi
    func getLatestHeight() async throws -> HealthSample? {
        guard let sample = try await service.readLatestHeightSample() else { return nil }
        let value = sample.quantity.doubleValue(for: HKUnit.meter()) * 100.0
        return HealthSample(
            type: .height,
            value: value,
            date: sample.startDate,
            sourceRevision: sample.sourceRevision,
            rawSample: sample
        )
    }
    
    /// Lukee viimeisimmän BMI:n ja muuntaa HealthSampleksi
    func getLatestBMI() async throws -> HealthSample? {
        guard let sample = try await service.readLatestBMISample() else { return nil }
        let value = sample.quantity.doubleValue(for: HKUnit.count())
        return HealthSample(
            type: .bmi,
            value: value,
            date: sample.startDate,
            sourceRevision: sample.sourceRevision,
            rawSample: sample
        )
    }
}
