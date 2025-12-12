//
//  YTravelsApp.swift
//  YTravels
//
//  Created by Волошин Александр on 11/7/25.
//

import SwiftUI

@main
struct YTravelsApp: App {
    
    @AppStorage("isDarkMode") var isDarkMode: Bool = false
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}
