//
//  CrossModel.swift
//  YTravels
//
//  Created by Волошин Александр on 12/11/25.
//

import Foundation

enum TimeOfDayType {
    case morning, day, afternoon, night, none
}

struct  CrossModel: Identifiable , Sendable{
    let id = UUID()
    let carrierName: String
    let carrierCode: String?
    let image: String = "travelLogo"// надо заиметь стоковое обозначение перевозчика по той причине что почему то сейчас запрос не возвращает картинки для аватарок рейсов
    let departureTime: String
    let arrivalTime: String
    let travelDuration: String
    let travelDate: String
    let hasTransfers: Bool
    let transferCity: String?
    let timeOfDay: TimeOfDayType
}
