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
                                hasChevron: false,
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
            .searchable(text: $searchText, prompt: "Введите запрос")
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
