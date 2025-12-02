import SwiftUI
import SwiftData

struct AddItemView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @Binding var lastAddedItemId: UUID?
    
    @State private var heightText: String = "155"
    @State private var weightText: String = ""
    @State private var errorMessage: String?
    
    private var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.locale = Locale.current       // esim. "fi_FI"
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 1
        return formatter
    }

    var body: some View {
        Form {
            Section(header: Text("Item details")) {
                TextField("Height (cm)", text: $heightText)
                    .keyboardType(.decimalPad)
                TextField("Weight (kg)", text: $weightText)
                    .keyboardType(.decimalPad)
            }
            if let error = errorMessage {
                Section {
                    Text(error)
                        .foregroundColor(.red)
                }
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
        let heightValue = heightText.replacingOccurrences(of: numberFormatter.decimalSeparator, with: ".")
        let weightValue = weightText.replacingOccurrences(of: numberFormatter.decimalSeparator, with: ".")
        
        guard
            let height = Double(heightValue),
            let weight = Double(weightValue)
        else {
            errorMessage = "Syötä kelvollinen luku (\(numberFormatter.decimalSeparator!) käytössä)."
            return
        }
        
        let bmi = weight / pow(height / 100.0, 2)
        
        let newItem = Item(
            timestamp: Date(),
            height: height,
            weight: weight,
            bmi: bmi
        )
        
        modelContext.insert(newItem)
        
        // Palautetaan ID
        lastAddedItemId = newItem.id
        
        dismiss()
    }
}

