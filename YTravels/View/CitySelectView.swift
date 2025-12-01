// CitySelectView.swift
import SwiftUI

struct CitySelectView: View {
    @Binding var selectedCity: String
    @Binding var selectedStation: String
    @Environment(\.dismiss) private var dismiss
    
    @State private var searchText = ""
    @State private var showStationSelect = false
    @State private var selectedCityForStations: CityStruct?
    
    private let cities = CityStruct.mockCities
    
    private var filteredCities: [CityStruct] {
        if searchText.isEmpty {
            return cities
        } else {
            return cities.filter { $0.city.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if filteredCities.isEmpty && !searchText.isEmpty {
                    VStack {
                        Spacer()
                        Text("Город не найден")
                            .font(.custom("SFProText-Bold", size: 24))
                        Spacer()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(Color(.systemBackground))
                } else {
                    List {
                        ForEach(filteredCities) { city in
                            SelectableCell(
                                title: city.city,
                                hasChevron: true,
                                action: {
                                    selectedCity = city.city
                                    selectedCityForStations = city
                                    showStationSelect = true
                                }
                            )
                            .listRowSeparator(.hidden)
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .searchable(text: $searchText, prompt: "Введите запрос")
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
            .fullScreenCover(isPresented: $showStationSelect) {
                if let city = selectedCityForStations {
                    StationSelectView(
                        selectedStation: $selectedStation,
                        stations: city.trainStations,
                        onStationSelected: { dismiss() }
                    )
                }
            }
        }
    }
}
