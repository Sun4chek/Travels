import Foundation

struct TrainStation: Identifiable, Hashable, Sendable {
    let id = UUID()
    let name: String
    let code: String
}

// Структура города

struct CityStruct: Identifiable, Hashable , Sendable {
    let id = UUID()
    let city: String
    let trainStations: [TrainStation]
}
