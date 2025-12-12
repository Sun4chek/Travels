//
//  SettingsViewModel.swift
//  YTravels
//
//  Created by Волошин Александр on 12/9/25.
//

import Combine
import SwiftUI

@MainActor
final class SettingsViewModel : ObservableObject {
    @AppStorage("isDarkMode") var isDarkMode: Bool = false {
        willSet{
            objectWillChange.send()
        }
    }

    
    
    @Published var showAgreement: Bool = false
    
    func openAgreement() {
        showAgreement = true
    }
}
