import XCTest
import HealthKit
@testable import VaaKit


// ******************
// tätä testiä varten pitää käynnistää sovellus simulaattorissa ja antaa luvat
// dataa pitää syöttää healthin kautta
// huom! xcode vaihtelee simulaattoreita kummallisesti
// storeen tallennuksia ei ole vielä testattu

final class HealthRepositoryIntegrationTests: XCTestCase {

    var store: HKHealthStore!
    var service: HealthKitService!
    var repository: HealthRepository!

    override func setUpWithError() throws {
        try super.setUpWithError()
        store = HKHealthStore()
        service = HealthKitService(store: store) // DI: simulatorin HKHealthStore
        repository = HealthRepository(service: service)
    }

    override func tearDownWithError() throws {
        store = nil
        service = nil
        repository = nil
        try super.tearDownWithError()
    }

    func testWeightHeightBMIFlow() async throws {
        let now = Date()
        
        // 1️⃣ Lisää testidataa simulatoriin
        
     //   try await service.requestAuthorization()

        // Paino
        let weightQuantity = HKQuantity(unit: .gramUnit(with: .kilo), doubleValue: 72.5)
        let weightSample = HKQuantitySample(
            type: HKQuantityType.quantityType(forIdentifier: .bodyMass)!,
            quantity: weightQuantity,
            start: now,
            end: now
        )
   //     try await store.save(weightSample)
        
        // Pituus
        let heightQuantity = HKQuantity(unit: HKUnit.meter(), doubleValue: 1.55)
        let heightSample = HKQuantitySample(
            type: HKQuantityType.quantityType(forIdentifier: .height)!,
            quantity: heightQuantity,
            start: now,
            end: now
        )
     //   try await store.save(heightSample)
        
        // BMI
        let bmiQuantity = HKQuantity(unit: HKUnit.count(), doubleValue: 30.0)
        let bmiSample = HKQuantitySample(
            type: HKQuantityType.quantityType(forIdentifier: .bodyMassIndex)!,
            quantity: bmiQuantity,
            start: now,
            end: now
        )
  //      try await store.save(bmiSample)
        
        // 2️⃣ Lue repositoryn kautta (tuotantokoodi)
        let weight = try await repository.getLatestWeight()
        let height = try await repository.getLatestHeight()
        let bmi = try await repository.getLatestBMI()
        
        // 3️⃣ Assertit
        XCTAssertNotNil(weight, "Painon pitäisi löytyä")
        XCTAssertEqual(weight!.value, 56.0, accuracy: 0.001)
       // XCTAssertEqual(weight!.date, now)
        
//        XCTAssertNotNil(height, "Pituuden pitäisi löytyä")
//        XCTAssertEqual(height!.value, 155.0, accuracy: 0.1) // cm
//        XCTAssertEqual(height!.date, now)
//        
//        XCTAssertNotNil(bmi, "BMI:n pitäisi löytyä")
//        XCTAssertEqual(bmi!.value, 30.0, accuracy: 0.001)
//        XCTAssertEqual(bmi!.date, now)
    }
}

