// ChooseDirectionView.swift
import SwiftUI

struct ChooseDirectionView: View {
    
    @EnvironmentObject var directionVM: ChooseDirectionViewModel
    
    private let mainViewHeight: CGFloat = 128
    
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.blue)
                .padding(.horizontal, 16)
                .frame(height: mainViewHeight)
            
            HStack {
                Spacer().frame(width: 16)
                
                VStack(spacing: 0) {
                    fromButton
                    toButton
                }
                .padding(.vertical, 16)
                .frame(height: mainViewHeight * 0.8)
                .frame(maxWidth: .infinity)
                .background(Color.white)
                .cornerRadius(20)
                
                swapButton
                    .padding(.leading, 16)
                    .padding(.trailing,16)
            }
            .frame(maxHeight: mainViewHeight)
            .padding(.horizontal, 16)
        }
        .padding(.top, 20)
        
        // Откуда
        .fullScreenCover(isPresented: $directionVM.showFromSheet) {
                    CitySelectView(
                        selectedCity: $directionVM.fromCity,
                        selectedStationName: $directionVM.fromStationName,
                        selectedStationCode: $directionVM.fromStationCode,
                        vm: directionVM.citySelectVM
                    )
            }
        
        // Куда
                .fullScreenCover(isPresented: $directionVM.showToSheet) {
                    CitySelectView(
                        selectedCity: $directionVM.toCity,
                        selectedStationName: $directionVM.toStationName,
                        selectedStationCode: $directionVM.toStationCode,
                        vm: directionVM.citySelectVM
                    )
                }
    }
    
    // Остальной код кнопок без изменений
    private var fromButton: some View {
        Button {
            directionVM.showFromSheet = true
        } label: {
            HStack {
                Text(directionVM.fromCity == "Откуда" ? "Откуда" : directionVM.fromDirection)
                    .font(.custom("SFProText-Regular", size: 17))
                    .foregroundColor(directionVM.fromCity == "Откуда" ? Color(.systemGray) : .black)
                    .lineLimit(1)
                Spacer()
            }
            .padding(.leading, 16)
            .padding(.vertical, 12)
        }
        .contentShape(Rectangle())
    }
    
    private var toButton: some View {
        Button {
            directionVM.showToSheet = true
        } label: {
            HStack {
                Text(directionVM.toCity == "Куда" ? "Куда" : directionVM.toDirection)
                    .font(.custom("SFProText-Regular", size: 17))
                    .foregroundColor(directionVM.toCity == "Куда" ? Color(.systemGray) : .black)
                    .lineLimit(1)
                Spacer()
            }
            .padding(.leading, 16)
            .padding(.vertical, 12)
        }
        .contentShape(Rectangle())
    }
    
    private var swapButton: some View {
        Button(action: { directionVM.swapDirections() }) {
            ZStack {
                RoundedRectangle(cornerRadius: 40)
                    .fill(Color.white)
                    .frame(width: 36, height: 36)
                    .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
                Image("SwapIcon")
                    .resizable()
                    .frame(width: 24, height: 24)
            }
        }
    }
}
