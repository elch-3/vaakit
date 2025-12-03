import XCTest
import HealthKit
@testable import VaaKit // vaihda omaan moduulin nimeen

final class HealthRepositoryTests: XCTestCase {
    
    var mockService: MockHealthKitService!
    var repository: HealthRepository!
    
    override func setUp() {
        super.setUp()
        mockService = MockHealthKitService()
        repository = HealthRepository(service: mockService)
    }
    
    override func tearDown() {
        repository = nil
        mockService = nil
        super.tearDown()
    }
    
    func testGetLatestWeightReturnsCorrectValue() async throws {
        // 💡 Arrange: luodaan fake HKQuantitySample painolle
        let quantity = HKQuantity(unit: .gramUnit(with: .kilo), doubleValue: 72.5)
        let sample = HKQuantitySample(
            type: HKQuantityType.quantityType(forIdentifier: .bodyMass)!,
            quantity: quantity,
            start: Date(timeIntervalSince1970: 1000),
            end: Date(timeIntervalSince1970: 1000)
        )
        mockService.fakeWeight = sample
        
        // 💡 Act
        let healthSample = try await repository.getLatestWeight()
        
        // 💡 Assert
        XCTAssertNotNil(healthSample, "HealthSample should not be nil")
        XCTAssertEqual(healthSample?.value, 72.5, accuracy: 0.001)
        XCTAssertEqual(healthSample?.date, sample.startDate)
        XCTAssertEqual(healthSample?.rawSample, sample)
    }
    
    func testGetLatestHeightReturnsCorrectValue() async throws {
        let quantity = HKQuantity(unit: HKUnit.meter(), doubleValue: 1.75)
        let sample = HKQuantitySample(
            type: HKQuantityType.quantityType(forIdentifier: .height)!,
            quantity: quantity,
            start: Date(timeIntervalSince1970: 2000),
            end: Date(timeIntervalSince1970: 2000)
        )
        mockService.fakeHeight = sample
        
        let healthSample = try await repository.getLatestHeight()
        
        XCTAssertNotNil(healthSample)
        XCTAssertEqual(healthSample?.value, 175.0, accuracy: 0.001) // metri → cm
        XCTAssertEqual(healthSample?.date, sample.startDate)
        XCTAssertEqual(healthSample?.rawSample, sample)
    }
    
    func testGetLatestBMIReturnsCorrectValue() async throws {
        let quantity = HKQuantity(unit: HKUnit.count(), doubleValue: 23.1)
        let sample = HKQuantitySample(
            type: HKQuantityType.quantityType(forIdentifier: .bodyMassIndex)!,
            quantity: quantity,
            start: Date(timeIntervalSince1970: 3000),
            end: Date(timeIntervalSince1970: 3000)
        )
        mockService.fakeBMI = sample
        
        let healthSample = try await repository.getLatestBMI()
        
        XCTAssertNotNil(healthSample)
        XCTAssertEqual(healthSample?.value, 23.1, accuracy: 0.001)
        XCTAssertEqual(healthSample?.date, sample.startDate)
        XCTAssertEqual(healthSample?.rawSample, sample)
    }
    
    func testGetLatestWeightReturnsNilIfNoData() async throws {
        mockService.fakeWeight = nil
        
        let healthSample = try await repository.getLatestWeight()
        
        XCTAssertNil(healthSample)
    }
}
