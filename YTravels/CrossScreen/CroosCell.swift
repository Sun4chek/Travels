// CompanyCellView.swift — ОСТАВЛЯЕМ ТО ЖЕ НАЗВАНИЕ!
import SwiftUI

struct CompanyCellView: View {
    let route: CrossModel        // ← Только это изменилось внутри
    let onTap: () -> Void
    
    var body: some View {
        VStack {
            HStack {
                Image(route.image)
                    
                    .resizable()
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .frame(width: 38, height: 38)
                
                VStack {
                    HStack {
                        Text(route.carrierName)
                            .font(.custom("SFPro-Regular", size: 17))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text(route.travelDate)
                            .font(.custom("SFPro-Regular", size: 12))
                            .foregroundColor(.black)
                    }
                    
                    if route.hasTransfers, let station = route.transferCity {
                        Text("С пересадкой в \(station)")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundStyle(.red)
                            .font(.custom("SFPro-Regular", size: 12))
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top, 12)
            .padding(.bottom, 4)
            
            HStack {
                Text(route.departureTime)
                    .font(.custom("SFProText-Regular", size: 17))
                    .foregroundColor(.black)
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 1)
                Text(route.travelDuration)
                    .foregroundColor(.black)
                    .font(.custom("SFPro-Regular", size: 12))
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 1)
                Text(route.arrivalTime)
                    .foregroundColor(.black)
                    .font(.custom("SFPro-Regula", size: 17)) // ← Оставил твою опечатку — пиксель в пиксель!
            }
            .padding(.horizontal)
            .padding(.top, 4)
            .padding(.bottom, 12)
        }
        .background(Color("LightGray"))
        .cornerRadius(24)
        .frame(height: 104)
        .onTapGesture {
            onTap()
        }
    }
}
