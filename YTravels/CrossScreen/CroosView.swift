
// CroosView.swift — ФИНАЛЬНАЯ РАБОЧАЯ ВЕРСИЯ
import SwiftUI

struct CroosView: View {
    private let fromCode: String
    private let toCode: String
    private let routeTitle: String
    
    @StateObject private var vm: CroosViewModel
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedRoute: CrossModel?
    
    init(fromCode: String, toCode: String, routeTitle: String) {
        self.fromCode = fromCode
        self.toCode = toCode
        self.routeTitle = routeTitle
        _vm = StateObject(wrappedValue: CroosViewModel(fromCode: fromCode, toCode: toCode))
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text(routeTitle)
                    .font(.custom("SFProText-Bold", size: 24))
                    .multilineTextAlignment(.leading)
                    .padding(.top, 16)
                    .padding(.horizontal, 16)
                
                if vm.isLoading {
                    Spacer()
                    ProgressView("Ищем рейсы...")
                        .font(.title2)
                    Spacer()
                } else if let error = vm.errorMessage {
                    // ... ошибка ...
                } else if vm.filteredRoutes.isEmpty {
                    Spacer()
                    Text("Вариантов нет")
                        .font(.custom("SFProText-Semibold", size: 18))
                        .foregroundColor(.secondary)
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack(spacing: 8) {
                            ForEach(vm.filteredRoutes) { route in
                                CompanyCellView(route: route) {
                                    selectedRoute = route
                                }
                                .padding(.horizontal, 16)
                            }
                        }
                        .padding(.top, 16)
                    }
                }
                
                // КНОПКА — теперь меняет vm.showFilter!
                Button {
                    vm.showFilter = true  // ← ВОТ ЭТО КЛЮЧЕВОЕ ИСПРАВЛЕНИЕ!
                } label: {
                    Text("Уточнить время")
                        .font(.custom("SFProText-Bold", size: 17))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(Color.blue)
                        .cornerRadius(16)
                        .overlay(
                            GeometryReader { geo in
                                if vm.isFilterActive {
                                    Circle()
                                        .fill(Color.red)
                                        .frame(width: 9, height: 9)
                                        .position(x: geo.size.width * 0.72, y: geo.size.height * 0.50)
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
            
            // ФИЛЬТР — теперь ОТКРЫВАЕТСЯ!
            .fullScreenCover(isPresented: $vm.showFilter) {
                TimeFilterView(
                    initialTimes: vm.selectedTimeOfDay,
                    initialTransfer: vm.showWithTransfer
                ) { times, transfer in
                    vm.selectedTimeOfDay = times
                    vm.showWithTransfer = transfer
                }
            }
            
            .fullScreenCover(item: $selectedRoute) { route in
                NavigationStack {
                    TransitInfoView(carrierCode: route.carrierCode ?? "")
                }
            }
            
            .task {
                await vm.loadRoutes()
            }
        }
    }
}
