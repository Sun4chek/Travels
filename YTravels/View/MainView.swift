//
//  MainView.swift
//  YTravels
//
//  Created by Волошин Александр on 11/24/25.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject private var vm: StoriesViewModel
    @EnvironmentObject private var directionVM: ChooseDirectionViewModel
    @State private var showFromSheet = false
    
    var body: some View {
        NavigationStack{
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(vm.stories) { story in
                            StoryesView(story: story)
                        }
                    }
                    .padding(.horizontal)
                }
                .frame(height: 140)
                .padding(.bottom, 24)
                
                ChooseDirectionView()
                    .padding(.bottom, 20)
                
                
                if directionVM.isBothDirectionsSelected {
                    Button {
                        showFromSheet = true
                    } label : {
                        ZStack{
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.blue)
                                .frame(height: 60)
                                .frame(width: 150)
                            
                            Text("Найти")
                                .font(.custom("SFProText-Bold",size: 17))
                                .foregroundColor(.white)
                        }
                    }
                    .fullScreenCover(isPresented: $showFromSheet) {
                        CroosView()
                            .environmentObject(directionVM)
                    }
                }
                
                Spacer()
            }
            .padding(.top, 24)
        }
    }
    
}

#Preview {
    MainView()
    
}
