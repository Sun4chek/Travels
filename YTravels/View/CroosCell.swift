import SwiftUI

struct CompanyCellView: View {
    let company: CompanyModel
    let onTap: () -> Void
    
    var body: some View {
        VStack {
            HStack {
                Image(company.image)
                    .frame(width: 38, height: 38)
                
                VStack {
                    HStack {
                        Text(company.companyName)
                            .font(.custom("SFPro-Regular", size: 17))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text(company.date)
                            .font(.custom("SFPro-Regular", size: 12))
                            .foregroundColor(.black)
                    }
                    
                    if company.needSwapStation, let station = company.swapStation {
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
                Text(company.timeToStart)
                    .font(.custom("SFProText-Regular", size: 17))
                    .foregroundColor(.black)
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    
                    .frame(height: 1)
                Text(company.allTimePath)
                    .foregroundColor(.black)
                    .font(.custom("SFPro-Regular", size: 12))
                Rectangle()
                    
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 1)
                Text(company.timeToOver)
                    .foregroundColor(.black)
                    .font(.custom("SFPro-Regula", size: 17))
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
