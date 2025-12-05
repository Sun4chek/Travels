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
            VStack(spacing: 0) {
                // ← ТОЛЬКО ЭТО ДОБАВЛЕНО: твоя кастомная строка поиска
                HStack {
                    Image("SearchBarFirst") // замени на свою иконку (или SearchBarSecond при вводе)
                        .resizable()
                        .frame(width: 20, height: 20)
                    
                    TextField("Введите запрос", text: $searchText)
                        .font(.custom("SFProText-Regular", size: 17))
                        .foregroundStyle(.primary)
                        .disableAutocorrection(true)
                        .textInputAutocapitalization(.never)
                    
                    if !searchText.isEmpty {
                        Button {
                            withAnimation(.easeInOut(duration: 0.15)) {
                                searchText = ""
                            }
                        } label: {
                            Image("CancelButton") // твоя иконка крестика
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
                
                // ← ВСЁ ОСТАЛЬНОЕ — ТВОЙ ОРИГИНАЛЬНЫЙ КОД БЕЗ ИЗМЕНЕНИЙ
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
