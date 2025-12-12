//
//  TransitInfoViewModel.swift
//  YTravels
//
//  Created by Волошин Александр on 12/12/25.
//

// TransitInfoViewModel.swift
import Foundation

@MainActor
final class TransitInfoViewModel: ObservableObject {
    @Published var info: TransitInfoModel?
    @Published var isLoading = true
    @Published var errorMessage: String? = nil
    
    private let carrierCode: String
    private let api = APIProvider.shared.yandexRasp
    
    init(carrierCode: String) {
        self.carrierCode = carrierCode
    }
    
    func loadCarrierInfo() async {
        isLoading = true
        errorMessage = nil
        
        do {
            info = try await api.getSimpleCarrierInfo(code: carrierCode)
        } catch {
            errorMessage = "Не удалось загрузить информацию"
            print("Ошибка: \(error)")
            
            // Фолбэк
            info = TransitInfoModel(
                name: "Информация недоступна",
                phone: "",
                email: "",
                logoUrl: ""
            )
        }
        
        isLoading = false
    }
}
