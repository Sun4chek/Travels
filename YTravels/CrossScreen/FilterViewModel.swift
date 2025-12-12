//
//  FilterViewModel.swift
//  YTravels
//
//  Created by Волошин Александр on 12/11/25.
//

// TimeFilterViewModel.swift
import Foundation

@MainActor
final class TimeFilterViewModel: ObservableObject {
    @Published var selectedTimeOfDay: Set<TimeOfDayType>
    @Published var showWithTransfer: Bool
    
    private let onApply: (Set<TimeOfDayType>, Bool) -> Void
    private let onCancel: () -> Void
    
    init(
        initialTimes: Set<TimeOfDayType>,
        initialTransfer: Bool,
        onApply: @escaping (Set<TimeOfDayType>, Bool) -> Void,
        onCancel: @escaping () -> Void = { }
    ) {
        self.selectedTimeOfDay = initialTimes
        self.showWithTransfer = initialTransfer
        self.onApply = onApply
        self.onCancel = onCancel
    }
    
    func apply() {
        onApply(selectedTimeOfDay, showWithTransfer)
    }
    
    func cancel() {
        onCancel()
    }
}
