// CompanyModel.swift
import Foundation

enum TimeOfDayType {
    case morning, day, afternoon, night, none
}

struct CompanyModel: Identifiable {
    let id = UUID()
    let companyName: String
    let fullImage : String
    let image: String
    let timeToStart: String
    let timeToOver: String
    let allTimePath: String
    let date: String
    let needSwapStation: Bool
    let swapStation: String?
    let timeOfDay: TimeOfDayType
    let mail : String
    let phone : String
}

extension CompanyModel {
    static let mockList: [CompanyModel] = [
        CompanyModel(
            companyName: "РЖД Экспресс",
            fullImage : "BigLogo",
            image: "2Logo",
            timeToStart: "06:15",
            timeToOver: "14:30",
            allTimePath: "8 ч",
            date: "16 ноября",
            needSwapStation: false,
            swapStation: nil,
            timeOfDay: .morning,
            mail : "info@rjd-express.ru",
            phone : "+7 (495) 123-45-67"
        ),
        CompanyModel(
            companyName: "МежгородАвто",
            fullImage: "2Logo",
            image: "1Logo",
            timeToStart: "08:45",
            timeToOver: "12:20",
            allTimePath: "4 ч",
            date: "17 ноября",
            needSwapStation: true,
            swapStation: "Ярославле",
            timeOfDay: .morning,
            mail : "info@rjd-express.ru",
            phone : "+7 (495) 123-45-67"
        ),
        CompanyModel(
            companyName: "АэроФлот Региональный",
            fullImage : "2Logo",
            image: "1Logo",
            timeToStart: "11:20",
            timeToOver: "13:50",
            allTimePath: "3 ч",
            date: "18 ноября",
            needSwapStation: false,
            swapStation: nil,
            timeOfDay: .morning,
            mail : "info@rjd-express.ru",
            phone : "+7 (495) 123-45-67"
        ),
        CompanyModel(
            companyName: "ТрансКарго",
            fullImage : "2Logo",
            image: "1Logo",
            timeToStart: "09:00",
            timeToOver: "21:30",
            allTimePath: "13 ч",
            date: "19 ноября",
            needSwapStation: true,
            swapStation: "Владимире",
            timeOfDay: .morning,
            mail : "info@rjd-express.ru",
            phone : "+7 (495) 123-45-67"
        ),
        CompanyModel(
            companyName: "Волна-Тур",
            fullImage : "2Logo",
            image: "2Logo",
            timeToStart: "15:40",
            timeToOver: "19:10",
            allTimePath: "4 ч",
            date: "20 ноября",
            needSwapStation: false,
            swapStation: nil,
            timeOfDay: .day,
            mail : "info@rjd-express.ru",
            phone : "+7 (495) 123-45-67"
        ),
        CompanyModel(
            companyName: "Скоростной Транзит",
            fullImage : "BigLogo",
            image: "2Logo",
            timeToStart: "07:30",
            timeToOver: "10:15",
            allTimePath: "3 ч",
            date: "21 ноября",
            needSwapStation: true,
            swapStation: "Твери",
            timeOfDay: .morning,
            mail : "info@rjd-express.ru",
            phone : "+7 (495) 123-45-67"
        ),
        CompanyModel(
            companyName: "Грузовой Альянс",
            fullImage : "2Logo",
            image: "2Logo",
            timeToStart: "22:00",
            timeToOver: "06:45",
            allTimePath: "9 ч",
            date: "22 ноября",
            needSwapStation: false,
            swapStation: nil,
            timeOfDay: .night,
            mail : "info@rjd-express.ru",
            phone : "+7 (495) 123-45-67"
        )
    ]
}
