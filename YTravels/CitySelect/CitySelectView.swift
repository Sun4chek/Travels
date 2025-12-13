import SwiftUI

struct CitySelectView: View {
    @Binding var selectedCity: String
    @Binding var selectedStationName: String
    @Binding var selectedStationCode: String
    
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var vm: CitySelectViewModel
    
    @State private var searchText = ""
    @State private var showStationSelect = false
    @State private var selectedCityForStations: CityStruct?
    

    
    private var filteredCities: [CityStruct] {
        if searchText.isEmpty {
            return vm.cities
        } else {
            return vm.cities.filter { $0.city.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                searchBar
                
                if vm.isLoading {
                    Spacer()
                    ProgressView("Загрузка городов...")
                        .progressViewStyle(.circular)
                        .scaleEffect(1.2)
                    Spacer()
                } else if let error = vm.errorMessage {
                    VStack(spacing: 16) {
                        Spacer()
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.orange)
                        
                        Text(error)
                            .multilineTextAlignment(.center)
                            .foregroundColor(.secondary)
                            .padding(.horizontal)
                        
                        Button("Повторить") {
                            Task { await vm.loadCities() }
                        }
                        .buttonStyle(.borderedProminent)
                        Spacer()
                    }
                } else if filteredCities.isEmpty && !searchText.isEmpty {
                    VStack {
                        Spacer()
                        Text("Город не найден")
                            .font(.custom("SFProText-Bold", size: 24))
                            .foregroundColor(.secondary)
                        Spacer()
                    }
                } else {
                    List {
                        ForEach(filteredCities) { city in
                            SelectableCell(
                                title: city.city,
                                hasChevron: true,
                                action: {
                                    selectedCity = city.city
                                    selectedCityForStations = city  // Передаём всю структуру с кодами
                                    showStationSelect = true
                                }
                            )
                            .listRowSeparator(.hidden)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Выбор города")
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
                }
            }
            .task {
                await vm.loadCities()  // Автозагрузка при появлении
            }
            .fullScreenCover(isPresented: $showStationSelect) {
                if let city = selectedCityForStations {
                    StationSelectView(
                        selectedStationName: $selectedStationName,  // ← Переименовать биндинг, если нужно
                        selectedStationCode : $selectedStationCode,  // ← Новый!
                        onStationSelected: { dismiss() },
                        vm: StationSelectViewModel(stations: city.trainStations.map { $0 })  // Передаём [TrainStation]
                    )
                }
            }
        }
    }
    
    private var searchBar: some View {
        HStack {
            Image("SearchBarFirst")
                .resizable()
                .frame(width: 20, height: 20)
            
            TextField("Введите запрос", text: $searchText)
                .font(.custom("SFProText-Regular", size: 17))
                .foregroundStyle(.primary)
                .disableAutocorrection(true)
                .textInputAutocapitalization(.never)
            
            if !searchText.isEmpty {
                Button {
                    withAnimation { searchText = "" }
                } label: {
                    Image("CancelButton")
                        .resizable()
                        .frame(width: 18, height: 18)
                        .foregroundStyle(.secondary)
                }
                .transition(.opacity)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(Color(.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding(.horizontal, 16)
        .padding(.top, 12)
        .padding(.bottom, 8)
    }
}
