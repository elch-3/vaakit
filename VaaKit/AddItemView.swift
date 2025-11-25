import SwiftUI
import SwiftData

struct AddItemView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var heightText: String = ""
    @State private var weightText: String = ""

    var body: some View {
        Form {
            Section(header: Text("Item details")) {
                TextField("Height (cm)", text: $heightText)
                    .keyboardType(.decimalPad)
                TextField("Weight (kg)", text: $weightText)
                    .keyboardType(.decimalPad)
            }
        }
        .navigationTitle("Add Item")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    save()
                }
                .disabled(heightText.isEmpty || weightText.isEmpty)
            }
            
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") { dismiss() }
            }
        }
    }

    private func save() {
        guard
            let height = Double(heightText),
            let weight = Double(weightText)
        else {
            return
        }

        let heightInMeters = height / 100.0
        let bmi = weight / (heightInMeters * heightInMeters)

        let newItem = Item(
            timestamp: Date(),
            height: height,
            weight: weight,
            bmi: bmi
        )
        modelContext.insert(newItem)
        dismiss()
    }
}

