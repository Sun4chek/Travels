//
//  CitySelectViewModel.swift
//  YTravels
//
//  Created by Волошин Александр on 12/10/25.
//

import Foundation
import Combine

@MainActor
class CitySelectViewModel: ObservableObject {
    @Published var cities: [CityStruct] = []
    @Published var isLoading = true
    @Published var errorMessage: String? = nil
    
    private let yandexAPI: YandexRaspAPI
    
    init(yandexAPI: YandexRaspAPI) {
        self.yandexAPI = yandexAPI
    }
    
    func loadCities() async {
        // Если уже загружены — ничего не делаем
        guard cities.isEmpty else {
            isLoading = false
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let fetchedCities = try await yandexAPI.getRussianTrainCities()
            cities = fetchedCities
        } catch {
            errorMessage = "Не удалось загрузить города.\nПроверьте интернет и попробуйте снова."
            print("Ошибка загрузки городов: \(error)")
            
        
        }
        
        isLoading = false
    }
}
