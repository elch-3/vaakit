import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var items: [Item]
    
    // State, joka hallitsee AddItemViewin näyttämistä
    @State private var showingAddItem = false

    var body: some View {
        NavigationSplitView {
            List {
                ForEach(items) { item in
                    Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .omitted))
                                   .font(.caption)
                                   .foregroundColor(.secondary)
               
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
                            Text("Height: \(String(format: "%.1f", item.height)) cm, Weight: \(String(format: "%.1f", item.weight)) kg, BMI: \(String(format: "%.1f", item.bmi))" )
                           // Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                          //      .font(.caption)
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
            // Avataan AddItemView modaalisesti
            .sheet(isPresented: $showingAddItem) {
                NavigationStack {
                    AddItemView()
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

@MainActor
func previewContainer() -> ModelContainer {
    let container = try! ModelContainer(
        for: Item.self,
        configurations: .init(schema: Schema([Item.self]), isStoredInMemoryOnly: true)
    )
    
    // Lisätään yksi testidata
    let context = container.mainContext
    let sampleItem = Item(
        timestamp: Date(),
        height: 175.0,
        weight: 70.0,
        bmi: 22.9
    )
    context.insert(sampleItem)
    
    return container
}

#Preview {
    ContentView()
        .modelContainer(previewContainer())
}


