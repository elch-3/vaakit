//
//  AppContainer.swift
//  VaaKit
//
//  Created by Abc Abc on 3.12.2025.
//


final class AppContainer {
    static let shared = AppContainer()

    // vaihdettavissa mock <-> oikea HealthKit
    var healthService: HealthServiceProtocol = HealthKitService()
}
