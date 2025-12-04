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
                .toolbar {
                      
                    // PLUS
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            showingAddItem = true
                        } label: {
                            Label("Add Item", systemImage: "plus")
                        }
                    }
                    // EDIT
                    ToolbarItem(placement: .navigationBarTrailing) {
                        EditButton()
                    }
           
                }
        }
        .sheet(isPresented: $showingAddItem) {
            NavigationStack {
               // AddItemView(lastAddedItemId: $lastAddedItemId)
                AddItemView()
            }
           // AddItemView()
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
                            Text((entry.date.formattedFinnish()))
                                .font(.headline)

                            HStack {
                                Text("\(entry.weight.formatted()) kg")
                                Text("BMI: \(entry.bmi.formatted())")
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
}
