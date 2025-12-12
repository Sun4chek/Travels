import Foundation

struct TrainStation: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let code: String
}

// Структура города
struct CityStruct: Identifiable, Hashable {
    let id = UUID()
    let city: String
    let trainStations: [TrainStation]
}
