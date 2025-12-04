//
//  HealthListViewModel.swift
//  VaaKit
//
//  Created by Abc Abc on 3.12.2025.
//


import SwiftUI
import HealthKit

// MARK: - ViewModel

@Observable
class HealthListViewModel {

    enum State {
        case loading
        case loaded([Entry])
        case error(String)
    }

    var state: State = .loading
    var healthAuthError: Error?

    private let healthRepo = AppContainer.shared.healthRepository

    @MainActor
    func load() async {
        state = .loading
        print("load alkaa")
        await requestHealthAuthorization()
        print("auth tehty")
        await fetchEntries()
        print("fetch tehty")
    }

    @MainActor
    private func requestHealthAuthorization() async {
         print("requestHealthAuthorization alkaa")
        do {
            try await healthRepo.requestAuthorization()
            print("HealthKit authorization ok")
        } catch {
            print("HealthKit authorization virhe: \(error)")
            healthAuthError = error
            state = .error("HealthKit-oikeudet evätty: \(error.localizedDescription)")
        }
    }

    @MainActor
    private func fetchEntries() async {

        do {
            async let weightSample = healthRepo.getLatestWeight()
            async let bmiSample = healthRepo.getLatestBMI()

            let latestWeight = try await weightSample   // HealthSample?
            let latestBmi    = try await bmiSample      // HealthSample?

            guard let w = latestWeight else {
                self.state = .error("Painotietoa ei löytynyt.")
                return
            }

            // täytetään Entry; jos bmi puuttuu, käytä nil → UI voi piirtää “–”
            let matchedBmi: Double? = {
                guard let b = latestBmi else { return nil }
                // yhdistetään vain jos päivä sama (tarkkuus: kalenteripäivä)
                if Calendar.current.isDate(w.date, inSameDayAs: b.date) {
                    return b.value
                }
                return nil
            }()

            let entry = Entry(
                date: w.date,
                weight: w.value,
                bmi: matchedBmi
            )
            print("Latest weight: \(String(describing: latestWeight)), BMI: \(String(describing: latestBmi))")
            self.state = .loaded([entry])

        } catch {
            self.state = .error("Tietojen haku epäonnistui: \(error.localizedDescription)")
        }
    }

}
