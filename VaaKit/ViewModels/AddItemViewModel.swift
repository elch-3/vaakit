//
//  AddItemViewModel.swift
//  VaaKit
//
//  Created by Abc Abc on 4.12.2025.
//

import Foundation


@MainActor
final class AddItemViewModel: ObservableObject {
    @Published var weightText: String = ""
    @Published var errorMessage: String?
    @Published var isSaving: Bool = false

    private let healthRepo: HealthRepository

    init(healthRepo: HealthRepository) {
        self.healthRepo = healthRepo
    }

    func save() async -> Bool {
        guard let weight = Double(weightText), weight > 0 else {
            errorMessage = "Syötä kelvollinen paino."
            return false
        }

        do {
            isSaving = true
            defer { isSaving = false }

            // Tarkista että pituus löytyy
            guard let heightSample = try await healthRepo.getLatestHeight() else {
                errorMessage = "Pituustietoa ei löytynyt. Lisää ensin pituus Health-sovelluksessa."
                isSaving = false
                return false
            }

            let heightCm = heightSample.value
            let bmi = weight / pow(heightCm / 100, 2)

            // Tallenna HealthKittiin
            try await healthRepo.saveWeight(weight)
            try await healthRepo.saveBMI(bmi)

            isSaving = false
            return true
        } catch {
            errorMessage = "Tallennus epäonnistui: \(error.localizedDescription)"
            isSaving = false
            return false
        }
    }
}
