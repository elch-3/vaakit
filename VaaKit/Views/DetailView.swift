//
//  DetailView.swift
//  VaaKit
//
//  Created by Abc Abc on 3.12.2025.
//
import SwiftUI

struct DetailView: View {
    let entry: Entry

    var body: some View {
        VStack(spacing: 20) {
            Text(formatDate(entry.date))
                .font(.title3)

            Text("Paino: \(entry.weight.formatted()) kg")
            Text("BMI: \(entry.bmi.formatted())")

            Spacer()
        }
        .padding()
        .navigationTitle("Tiedot")
    }

    private func formatDate(_ date: Date) -> String {
        let fmt = DateFormatter()
        fmt.dateStyle = .medium
        return fmt.string(from: date)
    }
}
