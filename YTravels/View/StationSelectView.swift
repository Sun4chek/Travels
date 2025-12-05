import SwiftUI

struct StationSelectView: View {
    @Binding var selectedStation: String
    let stations: [String]
    let onStationSelected: () -> Void
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var searchText = ""
    
    private var filteredStations: [String] {
        if searchText.isEmpty {
            return stations
        } else {
            return stations.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // ← ЭТО ЕДИНСТВЕННОЕ ИЗМЕНЕНИЕ: кастомный поиск вместо .searchable
                HStack {
                    Image("SearchBarFirst") // или SearchBarSecond — как у тебя в проекте
                        .resizable()
                        .frame(width: 20, height: 20)
                    
                    TextField("Введите запрос", text: $searchText)
                        .font(.custom("SFProText-Regular", size: 17))
                        .foregroundStyle(.primary)
                        .disableAutocorrection(true)
                        .textInputAutocapitalization(.never)
                    
                    // ← Крестик теперь точно виден
                    if !searchText.isEmpty {
                        Button {
                            withAnimation(.easeInOut(duration: 0.15)) {
                                searchText = ""
                            }
                        } label: {
                            Image("CancelButton") // ← твоя иконка крестика
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
                    if filteredStations.isEmpty && !searchText.isEmpty {
                        VStack {
                            Spacer()
                            Text("Станция не найдена")
                                .font(.custom("SFProText-Bold", size: 24))
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color(.systemBackground))
                    } else {
                        List {
                            ForEach(filteredStations, id: \.self) { station in
                                SelectableCell(
                                    title: station,
                                    hasChevron: true,
                                    action: {
                                        selectedStation = station
                                        onStationSelected()
                                    }
                                )
                                .listRowSeparator(.hidden)
                            }
                        }
                        .listStyle(.plain)
                    }
                }
            }
            .navigationTitle("Выбор станции")
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
        }
    }
}
