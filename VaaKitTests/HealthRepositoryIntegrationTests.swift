import XCTest
import HealthKit
@testable import VaaKit

final class HealthRepositoryIntegrationTests: XCTestCase {

    var store: HKHealthStore!
    var repository: HealthRepository!
    
    // Oikea HealthKitService tuotantoon
    var service: HealthKitService!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        store = HKHealthStore()
        service = HealthKitService(store: store) // oletetaan, että HealthKitService voidaan injektoida store
        repository = HealthRepository(service: service)
    }

    override func tearDownWithError() throws {
        store = nil
        repository = nil
        service = nil
        try super.tearDownWithError()
    }

    func testRepositoryReadsWeightHeightBMI() async throws {
        // 1️⃣ Request authorization in simulator
        try await service.requestAuthorization()
        
        // 2️⃣ Write sample data to HealthKit simulator
        let weightQuantity = HKQuantity(unit: .gramUnit(with: .kilo), doubleValue: 72.5)
        let weightSample = HKQuantitySample(
            type: HKQuantityType.quantityType(forIdentifier: .bodyMass)!,
            quantity: weightQuantity,
            start: Date(),
            end: Date()
        )
        try await store.save(weightSample)
        
        let heightQuantity = HKQuantity(unit: HKUnit.meter(), doubleValue: 1.55)
        let heightSample = HKQuantitySample(
            type: HKQuantityType.quantityType(forIdentifier: .height)!,
            quantity: heightQuantity,
            start: Date(),
            end: Date()
        )
        try await store.save(heightSample)
        
        let bmiQuantity = HKQuantity(unit: HKUnit.count(), doubleValue: 30.0)
        let bmiSample = HKQuantitySample(
            type: HKQuantityType.quantityType(forIdentifier: .bodyMassIndex)!,
            quantity: bmiQuantity,
            start: Date(),
            end: Date()
        )
        try await store.save(bmiSample)
        
        // 3️⃣ Read back through repository
        let weight = try await repository.getLatestWeight()
        let height = try await repository.getLatestHeight()
        let bmi = try await repository.getLatestBMI()
        
        // 4️⃣ Assertions
        XCTAssertNotNil(weight)
        XCTAssertEqual(weight!.value, 72.5, accuracy: 0.001)
        
        XCTAssertNotNil(height)
        XCTAssertEqual(height!.value, 155.0, accuracy: 0.1) // cm
        
        XCTAssertNotNil(bmi)
        XCTAssertEqual(bmi!.value, 30.0, accuracy: 0.001)
    }
}
