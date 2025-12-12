//
//  StationSelectViewModel.swift
//  YTravels
//
//  Created by Волошин Александр on 12/10/25.
//

// StationSelectViewModel.swift
import Foundation
import Combine

@MainActor  // Соответствует твоему требованию ко всем ViewModel
class StationSelectViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var stations: [TrainStation] = []
    
    // Вычисляемая фильтрация — теперь в ViewModel
    var filteredStations: [TrainStation] {
        if searchText.isEmpty {
            return stations
        } else {
            return stations.filter { $0.name.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    init(stations: [TrainStation]) {
        self.stations = stations
    }
    
    func clearSearch() {
        searchText = ""
    }
}
