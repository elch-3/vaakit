import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]

    @StateObject private var healthRepo = AppContainer.shared.healthRepository
    
    @State private var showingAddItem = false
    @State private var lastAddedItemId: UUID?

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Item created at:")
                            Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                                .font(.headline)

                            Text("Height: \(String(format: "%.1f", item.height)) cm")
                            Text("Weight: \(String(format: "%.1f", item.weight)) kg")
                            Text("BMI: \(String(format: "%.1f", item.bmi))")
                        }
                        .padding()
                    } label: {
                        VStack(alignment: .leading) {
                            Text("\(String(format: "%.1f", item.weight)) kg, BMI: \(String(format: "%.1f", item.bmi))")
                                .accessibilityIdentifier("itemRow_\(item.id.uuidString)") // ✅ UUID identifier
                        }
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button {
                        showingAddItem = true
                    } label: {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddItem) {
                NavigationStack {
                    AddItemView(lastAddedItemId: $lastAddedItemId)
                }
            }
        } detail: {
            Text("Select an item")
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(items[index])
            }
        }
    }
}

