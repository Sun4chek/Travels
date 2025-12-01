import SwiftUI

struct CroosView: View {
    @EnvironmentObject var directionVM: ChooseDirectionViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var showError = false
    @State private var showFilter = false
    
    private var filteredCompanies: [CompanyModel] {
        directionVM.filteredCompanies()
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text(directionVM.allRoad())
                    .font(.custom("SFProText-Bold", size: 24))
                    .multilineTextAlignment(.leading)
                    .padding(.top, 16)
                    .padding(.horizontal, 16)
                
                if filteredCompanies.isEmpty {
                    Spacer()
                    Text("Вариантов нет")
                        .font(.custom("SFProText-Semibold", size: 18))
                        .foregroundColor(.secondary)
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 8) {
                            ForEach(filteredCompanies) { company in
                                CompanyCellView(company: company) {
                                    showError = true
                                }
                                .padding(.horizontal, 16)
                            }
                        }
                        .padding(.top, 16)
                    }
                }
                
                Button {
                    showFilter = true
                } label: {
                    Text("Уточнить время")
                        .font(.custom("SFProText-Bold", size: 17))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(Color.blue)
                        .cornerRadius(16)
                        .overlay(
                            GeometryReader { geometry in
                                if directionVM.isFilterActive {
                                    Circle()
                                        .fill(Color.red)
                                        .frame(width: 9, height: 9)
                                        .position(
                                            x: geometry.size.width * 0.72, // Настройте множитель
                                            y: geometry.size.height * 0.50
                                        )
                                }
                            }
                        )
                }
                
                .padding(.horizontal, 16)
            }
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
            .fullScreenCover(isPresented: $showFilter) {
                TimeFilterView()
                    .environmentObject(directionVM)
            }
        }
        .fullScreenCover(isPresented: $showError) {
            NavigationStack {
                ErrorView(text: "Нет интернета", errorImageName: "ServerError")
                    .navigationTitle("Ошибка подключения")     // ← Заголовок
                    .navigationBarTitleDisplayMode(.inline)    // ← Как в РЖД
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button {
                                showError = false
                            } label: {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 18, weight: .semibold))
                            }
                        }
                    }
            }
        }
    }
}
