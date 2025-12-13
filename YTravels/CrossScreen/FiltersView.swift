import SwiftUI

// TimeFilterView.swift — 100% как у тебя было, только с правильной архитектурой
import SwiftUI

struct TimeFilterView: View {
    @StateObject private var vm: TimeFilterViewModel
    @Environment(\.dismiss) private var dismiss
    
    private let timeOptions = [
        ("Утро",   "06:00 - 12:00", TimeOfDayType.morning),
        ("День",   "12:00 - 18:00", TimeOfDayType.day),
        ("Вечер",  "18:00 - 00:00", TimeOfDayType.afternoon),
        ("Ночь",   "00:00 - 06:00", TimeOfDayType.night)
    ]
    
    init(
        initialTimes: Set<TimeOfDayType>,
        initialTransfer: Bool,
        onApply: @escaping (Set<TimeOfDayType>, Bool) -> Void
    ) {
        _vm = StateObject(wrappedValue: TimeFilterViewModel(
            initialTimes: initialTimes,
            initialTransfer: initialTransfer,
            onApply: onApply
        ))
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 0) {
                Text("Время отправления")
                    .font(.custom("SFProText-Bold", size: 24))
                    .padding(.horizontal, 16)
                    .padding(.top, 12)
                    .padding(.bottom, 24)
                
                VStack(spacing: 0) {
                    ForEach(timeOptions, id: \.2) { title, range, type in
                        TimeOfDayRow(
                            title: title,
                            timeRange: range,
                            isSelected: vm.selectedTimeOfDay.contains(type)
                        ) {
                            if vm.selectedTimeOfDay.contains(type) {
                                vm.selectedTimeOfDay.remove(type)
                            } else {
                                vm.selectedTimeOfDay.insert(type)
                            }
                        }
                    }
                }
                
                Divider()
                    .padding(.horizontal, 16)
                    .padding(.vertical, 24)
                
                VStack(alignment: .leading, spacing: 24) {
                    Text("Показывать варианты с пересадками")
                        .font(.custom("SFProText-Bold", size: 24))
                        .padding(.horizontal, 16)
                    
                    VStack(spacing: 20) {
                        TransferRow(title: "Да",  isSelected: vm.showWithTransfer) {
                            vm.showWithTransfer = true
                        }
                        TransferRow(title: "Нет", isSelected: !vm.showWithTransfer) {
                            vm.showWithTransfer = false
                        }
                    }
                    .padding(.horizontal, 16)
                }
                
                Spacer()
                
                Button {
                    vm.apply()
                    dismiss()
                } label: {
                    Text("Применить")
                        .font(.custom("SFProText-Bold", size: 17))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(Color.blue)
                        .cornerRadius(16)
                }
                .padding(.horizontal, 16)
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image("BackIcon")
                            .resizable()
                            .frame(width: 17, height: 22)
                    }
                    .padding(.leading, 8)
                }
            }
        }
    }
}
struct TimeOfDayRow: View {
    let title: String
    let timeRange: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        HStack {
            Text("\(title) \(timeRange)")
                .font(.custom("SFProText-Regular", size: 17))
                .foregroundColor(.primary)
            
            Spacer()
            ZStack {
                RoundedRectangle(cornerRadius: 4)
                    .stroke(Color.primary, lineWidth: 2)
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .fill(isSelected ? Color.primary : Color.clear)
                    )
                    .frame(width: 24, height: 24)
                
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(Color(.systemBackground))
                }
            }
        }
        .frame(height: 60)
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 16)
        .contentShape(Rectangle())
        .onTapGesture { action() }
    }
}

struct TransferRow: View {
    let  title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        HStack {
            Text(title)
                .font(.custom("SFProText-Regular", size: 17))
                .foregroundColor(.primary)
            
            Spacer()
            
            ZStack {
                Circle()
                    .stroke(Color.primary, lineWidth: 2)
                    .frame(width: 20, height: 20)
                
                if isSelected {
                    Circle()
                        .fill(Color.primary)               
                        .frame(width: 10, height: 10)
                }
            }
        }
        .frame(height: 44)
        .contentShape(Rectangle())
        .onTapGesture { action() }
    }
}

//#Preview {
//    TimeFilterView()
//        .environmentObject(ChooseDirectionViewModel())
//}
