//
//  ContentView.swift
//  VaaKit
//
//  Created by Abc Abc on 3.12.2025.
//


import SwiftUI

struct ContentView: View {
    @State private var vm = HealthListViewModel()
    @State private var showingAddItem = false
    @State private var isEditing = false

    @StateObject private var healthRepo = AppContainer.shared.healthRepository
 
    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Health-tiedot")
//                .toolbar {
//                    ToolbarItemGroup(placement: .navigationBarLeading) {
//                        EditButton()
//                    }
//                    
//                    ToolbarItemGroup(placement: .navigationBarTrailing) {
//                        Button {
//                            showingAddItem = true
//                        } label: {
//                            Image(systemName: "plus")
//                        }
//                    }
//                }
        }
        .sheet(isPresented: $showingAddItem) {
            AddItemView()
        }
        .task {
           await vm.load()
        }
    }

    @ViewBuilder
    private var content: some View {

        switch vm.state {
        case .loading:
   
            VStack {
                ProgressView()
                Text("Haetaan HealthKit-tietoja…")
                    .padding(.top, 4)
            }

        case .error(let message):
            VStack(spacing: 12) {
                Image(systemName: "exclamationmark.triangle")
                    .font(.largeTitle)
                Text(message)
                    .multilineTextAlignment(.center)
            }
            .padding()

        case .loaded(let entries):
            List {
                ForEach(entries) { entry in
                    NavigationLink {
                        DetailView(entry: entry)
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(formatDate(entry.date))
                                .font(.headline)

                            HStack {
                                Text("Paino: \(entry.weight, specifier: "%.1f") kg")
                                Text("BMI: \(entry.bmi.map { String(format: "%.1f", $0) } ?? "-")")
                            }
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        }
                    }
                }
                .onDelete(perform: delete)
            }
        }
    }

    private func delete(at offsets: IndexSet) {
    //    vm.delete(at: offsets)
    }

    private func formatDate(_ date: Date) -> String {
        let fmt = DateFormatter()
        fmt.dateStyle = .medium
        return fmt.string(from: date)
    }
    
}
