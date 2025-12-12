//
//  TransitInfoView.swift
//  YTravels
//
//  Created by Волошин Александр on 12/5/25.
//




import SwiftUI

struct TransitInfoView: View {
    
    @State var company : CompanyModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack{
            VStack(alignment: .leading, spacing : 16){
                Image(company.fullImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 24))
                Text(company.companyName)
                    .font(.custom("SFProText-Bold", size: 24))
                VStack{
                    VStack(alignment: .leading){
                        Text("E-mail")
                            .font(.custom("SFProText-Regular", size: 17))
                        Text(company.mail)
                            
                            .font(.custom("SFProText-Regular", size: 12))
                            .foregroundColor(.blue)
                    }
                    .frame( height: 60)
                    VStack(alignment: .leading){
                        Text("Телефон")
                            .font(.custom("SFProText-Regular", size: 17))
                        Text(company.phone)
                            .font(.custom("SFProText-Regular", size: 12))
                            .foregroundColor(.blue)
                    }
                    .frame( height: 60)
                }
                
            }
            .padding(.init(top: 16, leading: 16, bottom: 0, trailing: 16))
            Spacer()
        }
        .navigationTitle("Информация о перевозчике")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button { dismiss() } label: {
                    Image("BackIcon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 17, height: 22)
                }
                .padding(.leading, 8)
            }
        }
        
    }
}

#Preview {
    TransitInfoView(company: CompanyModel.mockList[0])
}
