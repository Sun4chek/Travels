// CroosViewModel.swift
import Foundation

@MainActor
final class CroosViewModel: ObservableObject {
    @Published var routes: [CrossModel] = []
    @Published var isLoading = true
    @Published var errorMessage: String? = nil
    
    // ФИЛЬТРЫ — теперь полностью здесь!
    @Published var selectedTimeOfDay: Set<TimeOfDayType> = [.morning, .day, .afternoon, .night]
    @Published var showWithTransfer = true
    
    @Published var showFilter = false
    @Published var selectedRoute: CrossModel?
    
    private let fromCode: String
    private let toCode: String
    private let api = APIProvider.shared.yandexRasp
    
    init(fromCode: String, toCode: String) {
        self.fromCode = fromCode
        self.toCode = toCode
    }
    
    func loadRoutes() async {
        isLoading = true
        errorMessage = nil
        
        do {
            routes = try await api.getTrainRoutesWithTransfers(from: fromCode, to: toCode)
        } catch {
            errorMessage = "Не удалось загрузить рейсы"
            print("Ошибка: \(error)")
        }
        
        isLoading = false
    }
    
    var isFilterActive: Bool {
        selectedTimeOfDay != [.morning, .day, .afternoon, .night] || !showWithTransfer
    }
    
    var filteredRoutes: [CrossModel] {
        routes.filter { route in
            selectedTimeOfDay.contains(route.timeOfDay) &&
            (showWithTransfer || !route.hasTransfers)
        }
    }
}
