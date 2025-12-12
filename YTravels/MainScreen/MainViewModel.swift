//
//  MainViewModel.swift
//  YTravels
//
//  Created by Волошин Александр on 12/10/25.
//

import Foundation
import Combine

@MainActor
class MainViewModel: ObservableObject {
    // Для показа полного экрана сторис
    @Published var selectedStory: Storyes? = nil
    
    // Для показа экрана поиска (CroosView)
    @Published var shouldPresentSearch = false
    
    // Опционально: если нужно больше логики (например, валидация перед поиском)
    func searchButtonTapped() {
        // Здесь можно добавить любую логику перед показом (например, валидацию)
        shouldPresentSearch = true
    }
    
    // Если хочешь сбрасывать после закрытия
    func resetSearchPresentation() {
        shouldPresentSearch = false
    }
}
