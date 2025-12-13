// TransitInfoView.swift — ПИКСЕЛЬ В ПИКСЕЛЬ КАК У ТЕБЯ (все отступы 16 от краёв)
import SwiftUI

struct TransitInfoView: View {
    let carrierCode: String
    
    @StateObject private var vm: TransitInfoViewModel
    
    @Environment(\.dismiss) private var dismiss
    
    init(carrierCode: String) {
        self.carrierCode = carrierCode
        _vm = StateObject(wrappedValue: TransitInfoViewModel(carrierCode: carrierCode))
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                // ЛОГОТИП — высота 104, полный ширины с отступами 16
                if vm.isLoading {
                    ProgressView()
                        .frame(height: 104)
                        .frame(maxWidth: .infinity)
                } else if let urlStr = vm.info?.logoUrl, !urlStr.isEmpty, let url = URL(string: urlStr) {
                    AsyncImage(url: url) { phase in
                        if let image = phase.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(height: 104)
                                .clipShape(RoundedRectangle(cornerRadius: 24))
                        } else {
                            fallbackLogo
                        }
                    }
                    .frame(maxWidth: .infinity)
                } else {
                    fallbackLogo
                        .frame(maxWidth: .infinity)
                }
                
                // Название — отступ 16 слева
                Text(vm.info?.name ?? "Загрузка...")
                    .font(.custom("SFProText-Bold", size: 24))
                
                // КОНТАКТЫ — два блока друг под другом, отступы только от внешнего padding
                VStack(spacing: 0) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("E-mail")
                            .font(.custom("SFProText-Regular", size: 17))
                        Text(vm.info?.email ?? "")
                            .font(.custom("SFProText-Regular", size: 12))
                            .foregroundColor(.blue)
                            .onTapGesture {
                                if let email = vm.info?.email, !email.isEmpty {
                                    if let url = URL(string: "mailto:\(email)") {
                                        UIApplication.shared.open(url)
                                    }
                                }
                            }
                    }
                    .frame(height: 60)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Телефон")
                            .font(.custom("SFProText-Regular", size: 17))
                        Text(vm.info?.phone ?? "")
                            .font(.custom("SFProText-Regular", size: 12))
                            .foregroundColor(.blue)
                            .onTapGesture {
                                if let phone = vm.info?.phone, !phone.isEmpty {
                                    let cleaned = phone.filter { $0.isNumber }
                                    if let url = URL(string: "tel:\(cleaned)") {
                                        UIApplication.shared.open(url)
                                    }
                                }
                            }
                    }
                    .frame(height: 60)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Spacer()
            }
            .padding(.horizontal, 16)  // ← ЕДИНЫЙ ОТСТУП 16 ОТ КРАЁВ ДЛЯ ВСЕГО КОНТЕНТА
            .padding(.top, 16)
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
            .task {
                await vm.loadCarrierInfo()
            }
        }
    }
    
    private var fallbackLogo: some View {
        Image("defaultLogo")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(height: 104)
            .clipShape(RoundedRectangle(cornerRadius: 24))
    }
}
