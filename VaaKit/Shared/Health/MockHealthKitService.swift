//
//  MockHealthKitService.swift
//  VaaKit
//
//  Created by Abc Abc on 3.12.2025.
//


import Foundation
import HealthKit

final class MockHealthKitService: HealthServiceProtocol {

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
        // mock: voi tallentaa local variableen
    }
    
    func writeBMI(_ value: Double) async throws {
        // mock: voi tallentaa local variableen
    }
}
