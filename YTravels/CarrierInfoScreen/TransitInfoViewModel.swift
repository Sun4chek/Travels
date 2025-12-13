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
    private let apiProvider = APIProvider.shared
    
    init(carrierCode: String) {
        self.carrierCode = carrierCode
    }
    
    func loadCarrierInfo() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let provider = apiProvider
            
            // 2. Теперь мы "внутри" actor и можем получить свойство
            let api = provider.yandexRasp
            
            // 3. Вызываем async метод
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
