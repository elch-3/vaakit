@MainActor
final class AddItemViewModel: ObservableObject {
    @Published var weightText: String = ""
    @Published var errorMessage: String?
    @Published var isSaving: Bool = false

    private let healthRepo: HealthRepository

    init(healthRepo: HealthRepository) {
        self.healthRepo = healthRepo
    }

    func save() async {
        guard let weight = Double(weightText), weight > 0 else {
            errorMessage = "Syötä kelvollinen paino."
            return
        }

        do {
            isSaving = true

            // Tarkista että pituus löytyy
            guard let heightSample = try await healthRepo.getLatestHeight() else {
                errorMessage = "Pituustietoa ei löytynyt. Lisää ensin pituus."
                isSaving = false
                return
            }

            let heightCm = heightSample.value
            let bmi = weight / pow(heightCm / 100, 2)

            // Tallenna HealthKittiin
            try await healthRepo.saveWeight(weight)
            try await healthRepo.saveBMI(bmi)

            isSaving = false
        } catch {
            errorMessage = "Tallennus epäonnistui: \(error.localizedDescription)"
            isSaving = false
        }
    }
}
