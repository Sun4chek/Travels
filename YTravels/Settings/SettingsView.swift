//
//  SettingsView.swift
//  YTravels
//
//  Created by Волошин Александр on 11/24/25.
//

import SwiftUI

struct SettingsView: View {
    
    @StateObject private var viewModel = SettingsViewModel()

    var body: some View {
        VStack {
            HStack{
                Text("Темная тема")
                    .font(.custom("SFProText-Regular", size: 17))
                Toggle("", isOn: $viewModel.isDarkMode)
            }
            .frame(height: 60 )
           Button {
               viewModel.openAgreement()
            } label : {
                HStack{
                    Text("Пользовательское соглашение")
                        .font(.custom("SFProText-Regular", size: 17))
                        .foregroundColor(.primary)
                    Spacer()
                    Image("NextIcon")
                }
            }
            .frame(height: 60 )
            
            Spacer()
            
        }
        .padding(.init(top: 24, leading: 16, bottom: 0, trailing: 16))
        .fullScreenCover(isPresented: $viewModel.showAgreement) {
                    UserAgreementView()
        }
    }
}

#Preview {
    SettingsView()
    
}

