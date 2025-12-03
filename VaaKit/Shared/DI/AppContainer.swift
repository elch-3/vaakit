//
//  AppContainer.swift
//  VaaKit
//
//  Created by Abc Abc on 3.12.2025.
//

final class AppContainer {
    static let shared = AppContainer()

    // Service voidaan vaihtaa mockiin tai oikeaan HealthKitServiceen
    var healthService: HealthServiceProtocol = HealthKitService()

    // Repository voidaan rakentaa käyttämään tätä serviceä
    lazy var healthRepository: HealthRepository = HealthRepository(service: healthService)
}
