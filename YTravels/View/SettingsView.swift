//
//  SettingsView.swift
//  YTravels
//
//  Created by Волошин Александр on 11/24/25.
//

import SwiftUI

struct SettingsView: View {
    
    @AppStorage("isDarkMode") var isOn: Bool = false
    @State private var showAgreement = false

    var body: some View {
        VStack {
            HStack{
                Text("Темная тема")
                    .font(.custom("SFProText-Regular", size: 17))
                Toggle("", isOn: $isOn)
            }
            .frame(height: 60 )
           Button {
                showAgreement = true
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
        .fullScreenCover(isPresented: $showAgreement) {
                    UserAgreementView()
        }
    }
}

#Preview {
    SettingsView()
    
}

