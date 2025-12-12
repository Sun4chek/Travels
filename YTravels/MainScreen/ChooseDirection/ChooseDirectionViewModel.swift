import Foundation

@MainActor
class ChooseDirectionViewModel: ObservableObject {
    @Published var showFromSheet = false
    @Published var showToSheet = false
    
    @Published var fromCity = "Откуда"
    @Published var toCity = "Куда"

    
    @Published var fromStationName = ""
    @Published var fromStationCode = ""
    @Published var toStationName = ""
    @Published var toStationCode = ""
    
    @Published var citySelectVM: CitySelectViewModel
    @Published var selectedTimeOfDay: Set<TimeOfDayType> = [.morning, .day, .afternoon, .night]
    @Published var showWithTransfer = true
    
    init() {
            let api = APIProvider.shared.yandexRasp
            self.citySelectVM = CitySelectViewModel(yandexAPI: api)
            
            // Предзагрузка
            Task {
                await citySelectVM.loadCities()
            }
        }
    

    
    var fromDirection: String {
        fromStationName.isEmpty ? fromCity : "\(fromCity)(\(fromStationName))"
    }
    
    var toDirection: String {
        toStationName.isEmpty ? toCity : "\(toCity)(\(toStationName))"
    }
    
    var isBothDirectionsSelected: Bool {
            fromCity != "Откуда" && !fromStationCode.isEmpty &&
            toCity != "Куда" && !toStationCode.isEmpty
        }
    
    func setFrom(city: String, stationName: String, stationCode: String) {
            fromCity = city
            fromStationName = stationName
            fromStationCode = stationCode
        }
    
    func setTo(city: String, stationName: String, stationCode: String) {
            toCity = city
            toStationName = stationName
            toStationCode = stationCode
        }
    
    // Метод свапа — обновлённый
        func swapDirections() {
            let fromIsDefault = (fromCity == "Откуда" && fromStationCode.isEmpty)
            let toIsDefault   = (toCity == "Куда" && toStationCode.isEmpty)
            
            if fromIsDefault && toIsDefault { return }
            
            if fromIsDefault {
                fromCity = toCity
                fromStationName = toStationName
                fromStationCode = toStationCode
                
                toCity = "Куда"
                toStationName = ""
                toStationCode = ""
                return
            }
            
            if toIsDefault {
                toCity = fromCity
                toStationName = fromStationName
                toStationCode = fromStationCode
                
                fromCity = "Откуда"
                fromStationName = ""
                fromStationCode = ""
                return
            }
            
            // Полный свап
            swap(&fromCity, &toCity)
            swap(&fromStationName, &toStationName)
            swap(&fromStationCode, &toStationCode)
        }
    
    func allRoad() -> String {
        "\(fromDirection) → \(toDirection)"
    }
}
