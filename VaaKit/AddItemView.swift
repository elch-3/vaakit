import SwiftUI
import SwiftData

struct AddItemView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var field1: String = ""
    @State private var field2: String = ""

    var body: some View {
        Form {
            Section(header: Text("Item details")) {
                TextField("First field", text: $field1)
                TextField("Second field", text: $field2)
            }
        }
        .navigationTitle("Add Item")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    save()
                }
                .disabled(field1.isEmpty || field2.isEmpty)
            }
            
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") { dismiss() }
            }
        }
    }

    private func save() {
        let newItem = Item(
            timestamp: Date(),
            field1: field1,
            field2: field2
        )
        modelContext.insert(newItem)
        dismiss()
    }
}
