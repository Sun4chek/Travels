import SwiftUI

struct StationSelectView: View {
    @Binding var selectedStationName: String
    @Binding var selectedStationCode: String
    
    let onStationSelected: () -> Void
    
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var vm: StationSelectViewModel  // ← ObservedObject — ViewModel снаружи
    
    // Убрали @State searchText — теперь во ViewModel
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                searchBar
                
                Group{
                    if vm.filteredStations.isEmpty && !vm.searchText.isEmpty {
                        VStack {
                            Spacer()
                            Text("Станция не найдена")
                                .font(.custom("SFProText-Bold", size: 24))
                                .foregroundColor(.secondary)
                            Spacer()
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color(.systemBackground))
                    } else {
                        List {
                            ForEach(vm.filteredStations ) { station in
                                SelectableCell(
                                    title: station.name,
                                    hasChevron: true,
                                    action: {
                                        selectedStationName = station.name
                                        selectedStationCode = station.code
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
    
    private var searchBar: some View {
        HStack {
            Image("SearchBarFirst")
                .resizable()
                .frame(width: 20, height: 20)
            
            TextField("Введите запрос", text: $vm.searchText)  // ← Биндинг к vm.searchText
                .font(.custom("SFProText-Regular", size: 17))
                .foregroundStyle(.primary)
                .disableAutocorrection(true)
                .textInputAutocapitalization(.never)
            
            if !vm.searchText.isEmpty {
                Button {
                    withAnimation(.easeInOut(duration: 0.15)) {
                        vm.searchText = ""
                    }
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
