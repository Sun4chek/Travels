import Foundation

class ChooseDirectionViewModel: ObservableObject {
    @Published var fromCity = "Откуда"
    @Published var toCity = "Куда"
    @Published var fromStation = ""
    @Published var toStation = ""
    
    @Published var selectedTimeOfDay: Set<TimeOfDayType> = [.morning, .day, .afternoon, .night]
    @Published var showWithTransfer = true
    
    var isFilterActive: Bool {
            let defaultTimes: Set<TimeOfDayType> = [.morning, .day, .afternoon, .night]
            
            return selectedTimeOfDay != defaultTimes || !showWithTransfer
        }
    
    var fromDirection: String {
        fromStation.isEmpty ? fromCity : "\(fromCity)(\(fromStation))"
    }
    
    var toDirection: String {
        toStation.isEmpty ? toCity : "\(toCity)(\(toStation))"
    }
    
    var isBothDirectionsSelected: Bool {
        fromCity != "Откуда" && !fromStation.isEmpty &&
        toCity != "Куда" && !toStation.isEmpty
    }
    
    func setFrom(city: String, station: String) {
        fromCity = city
        fromStation = station
    }
    
    func setTo(city: String, station: String) {
        toCity = city
        toStation = station
    }
    
    func swapDirections() {
        let tempCity = fromCity
        let tempStation = fromStation
        fromCity = toCity
        fromStation = toStation
        toCity = tempCity
        toStation = tempStation
    }
    
    func allRoad() -> String {
        "\(fromDirection) → \(toDirection)"
    }
    
    func filteredCompanies() -> [CompanyModel] {
        CompanyModel.mockList.filter { company in
            let matchesTime = selectedTimeOfDay.contains(company.timeOfDay)
            let matchesTransfer = showWithTransfer || !company.needSwapStation
            return matchesTime && matchesTransfer
        }
    }
}
