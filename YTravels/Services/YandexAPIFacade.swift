import OpenAPIRuntime
import OpenAPIURLSession
import Foundation

actor YandexRaspAPI {
    private var cachedRussianCities: [CityStruct]? = nil
    private let nearestStationsService: NearestStationsServiceProtocol
    private let scheduleBetweenStationsService: ScheduleBetweenStationsServiceProtocol
    private let stationScheduleService: StationScheduleServiceProtocol
    private let routeStationsService: RouteStationsServiceProtocol
    private let nearestSettlementService: NearestSettlementProtocol
    private let carrierInfoService: CarrierProtocol
    private let allStationsService: AllStationsServiceProtocol
    private let copyrightService: CopyrightServiceProtocol
    
    init(client: Client, apikey: String) {
        self.nearestStationsService = NearestStationsService(client: client, apikey: apikey)
        self.scheduleBetweenStationsService = ScheduleBetweenStationsService(client: client, apikey: apikey)
        self.stationScheduleService = StationScheduleService(client: client, apikey: apikey)
        self.routeStationsService = RouteStationsService(client: client, apikey: apikey)
        self.carrierInfoService = CarrierService(client: client, apikey: apikey)
        self.allStationsService = AllStationsService(client: client, apikey: apikey)
        self.nearestSettlementService = NearestSettlementService(client: client, apikey: apikey)
        self.copyrightService = CopyrightService(client: client, apikey: apikey)
    }
    
    func getNearestStations(lat: Double, lng: Double, distance: Int) async throws -> NearestStations {
        try await nearestStationsService.getNearestStations(lat: lat, lng: lng, distance: distance)
    }
    
    func getScheduleBetweenStations(from: String, to: String,transfers : Bool ) async throws -> Segments {
        try await scheduleBetweenStationsService.getSchedule(from: from, to: to,transfers: transfers )
    }
    
    func getStationSchedule(station: String, date: String?) async throws -> StationSchedule {
        try await stationScheduleService.getSchedule(station: station)
    }
    
    func getRouteStation(uid: String) async throws -> ThreadStationsResponse {
        try await routeStationsService.getRouteStation(uid: uid)
    }
    
    func getNearestSettlement(lat: Double, lng: Double) async throws -> NearestSettlement{
        try await nearestSettlementService.getNearestSettlement(lat: lat, lng: lng)
    }
    
    func getCarrierInfo(code: String, system: String?) async throws -> Carrier{
        try await carrierInfoService.getCarrier(code: code, system: system)
    }
    
    func getAllStations() async throws -> AllStations {
        try await allStationsService.getAllStations()
    }
    
    func getCopyright() async throws -> CopyrightResponse {
        try await copyrightService.getCopyright()
    }
}
extension YandexRaspAPI {
    
   // ← Кэш теперь для новой структуры
    
    func getRussianTrainCities() async throws -> [CityStruct] {
        // Если уже загружали — возвращаем из памяти
        if let cached = cachedRussianCities {
            print("Города с станциями взяты из кэша: \(cached.count) шт.")
            return cached
        }
        
        print("Загружаем полный список станций с сервера...")
        
        let allStations = try await getAllStations()
        
        guard let countries = allStations.countries else {
            print("❌ countries == nil")
            return []
        }
        
        guard let russia = countries.first(where: { $0.codes?.yandex_code == "l225" }) else {
            print("❌ Russia not found")
            return []
        }
        
        var cities: [CityStruct] = []
        
        for region in russia.regions ?? [] {
            for settlement in region.settlements ?? [] {
                guard let cityName = settlement.title, !cityName.isEmpty else { continue }
                
                // Фильтруем только железнодорожные станции и собираем с кодом
                let trainStations: [TrainStation] = settlement.stations?.compactMap { station -> TrainStation? in
                    guard let type = station.station_type?.lowercased(),
                          type == "train_station" || type == "station",
                          let stationTitle = station.title,
                          let yandexCode = station.codes?.yandex_code else {
                        return nil
                    }
                    return TrainStation(name: stationTitle, code: yandexCode)
                } ?? []
                
                // Добавляем город только если есть хотя бы одна ж/д станция
                if !trainStations.isEmpty {
                    cities.append(CityStruct(city: cityName, trainStations: trainStations))
                }
            }
        }
        
        let sortedCities = cities.sorted { $0.city < $1.city }
        
        // Сохраняем в кэш
        cachedRussianCities = sortedCities
        
        print("Успешно загружено и закэшировано городов с ж/д станциями: \(sortedCities.count)")
        
        return sortedCities
    }
}

extension YandexRaspAPI {
    
    // === ГЛАВНЫЙ МЕТОД — СРАЗУ ВОЗВРАЩАЕТ CrossModel ===
    func getTrainRoutesWithTransfers(from: String, to: String) async throws -> [CrossModel] {
        let response = try await getScheduleBetweenStations(from: from, to: to, transfers: true)
        
        guard let segments = response.segments, !segments.isEmpty else {
            print("Нет доступных рейсов")
            return []
        }
        
        let groupedRoutes = groupSegmentsIntoRoutes(segments)
        var result: [CrossModel] = []
        
        for routeSegments in groupedRoutes {
            guard let first = routeSegments.first,
                  let last = routeSegments.last,
                  let thread = first.thread,
                  let departureStr = first.departure,
                  let arrivalStr = last.arrival,
                  let dateStr = first.start_date else {
                continue
            }
            
            let carrierName = thread.carrier?.title ?? "Неизвестный перевозчик"
            let carrierCode = thread.carrier?.code.flatMap { String($0) }
            
            let totalSeconds = routeSegments.reduce(0) { $0 + ($1.duration ?? 0) }
            let duration = formatDuration(seconds: totalSeconds)
            
            let departureTime = extractTime(from: departureStr)
            let arrivalTime = extractTime(from: arrivalStr)
            let travelDate = formatDateString(dateStr)
            let hasTransfers = routeSegments.count > 1
            let transferCity = hasTransfers ? extractCityFromStationName(first.to?.title) : nil
            let timeOfDay = timeOfDay(from: departureTime)
            
            let model = CrossModel(
                carrierName: carrierName,
                carrierCode: carrierCode,
                departureTime: departureTime,
                arrivalTime: arrivalTime,
                travelDuration: duration,
                travelDate: travelDate,
                hasTransfers: hasTransfers,
                transferCity: transferCity,
                timeOfDay: timeOfDay
            )
            
            result.append(model)
        }
        
        return result.sorted { $0.departureTime < $1.departureTime }
    }
    
    // === Время суток ===
    private func timeOfDay(from timeString: String) -> TimeOfDayType {
        // Безопасно берём первые два символа
        let prefix = timeString.prefix(2)
        guard prefix.count == 2,
              let hour = Int(prefix) else {
            return .none
        }
        
        switch hour {
        case 5..<12:  return .morning
        case 12..<18: return .day
        case 18..<23: return .afternoon
        default:      return .night
        }
    }
    
    // === Группировка сегментов (остаётся без изменений) ===
    private func groupSegmentsIntoRoutes(_ segments: [Components.Schemas.Segment]) -> [[Components.Schemas.Segment]] {
        var routes: [[Components.Schemas.Segment]] = []
        var current: [Components.Schemas.Segment] = []
        
        let sorted = segments.sorted { seg1, seg2 in
            guard let d1 = seg1.departure, let d2 = seg2.departure else { return false }
            return d1 < d2
        }
        
        for seg in sorted {
            if current.isEmpty {
                current.append(seg)
            } else if let last = current.last, segmentsAreConnected(last, seg) {
                current.append(seg)
            } else {
                routes.append(current)
                current = [seg]
            }
        }
        if !current.isEmpty { routes.append(current) }
        
        return routes
    }
    
    private func segmentsAreConnected(_ s1: Components.Schemas.Segment, _ s2: Components.Schemas.Segment) -> Bool {
        guard let code1 = s1.to?.codes?.yandex_code,
              let code2 = s2.from?.codes?.yandex_code else { return false }
        return code1 == code2
    }
    
    // === Вспомогательные функции (всё как было) ===
    private func formatDuration(seconds: Int) -> String {
        let h = seconds / 3600
        let m = (seconds % 3600) / 60
        return h > 0 ? "\(h)ч \(m)мин" : "\(m)мин"
    }
    
    private func extractTime(from str: String) -> String {
        str.contains("T") ? String(str.split(separator: "T")[1].prefix(5)) : String(str.prefix(5))
    }
    
    private func formatDateString(_ str: String) -> String {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        let out = DateFormatter()
        out.dateFormat = "dd.MM.yyyy"
        if let d = f.date(from: str) { return out.string(from: d) }
        return str
    }
    
    private func extractCityFromStationName(_ name: String?) -> String? {
        guard let n = name else { return nil }
        let known = ["Москва", "Санкт-Петербург", "Екатеринбург", "Новосибирск", "Казань", "Нижний Новгород", "Самара"]
        for city in known where n.contains(city) { return city }
        if let p = n.range(of: " (") { return String(n[..<p.lowerBound]).trimmingCharacters(in: .whitespaces) }
        if let d = n.range(of: "-"), !n.lowercased().hasPrefix("санкт-петербург") {
            return String(n[..<d.lowerBound]).trimmingCharacters(in: .whitespaces)
        }
        return n
    }
}

extension YandexRaspAPI {
    
    // Простая функция для получения информации о перевозчике
    func getSimpleCarrierInfo(code: String) async throws -> TransitInfoModel {
        let carrierResponse = try await carrierInfoService.getCarrier(code: code, system: nil)
        
        // Ищем перевозчика в ответе
        if let carrier = carrierResponse.carrier {
            return TransitInfoModel(
                name: carrier.title ?? "Неизвестный перевозчик",
                phone: carrier.phone ?? "Телефон не указан",
                email: carrier.email ?? "Email не указан",
                logoUrl: carrier.logo ?? "Нет картинки"
            )
        } else if let carriers = carrierResponse.carriers, let firstCarrier = carriers.first {
            return TransitInfoModel(
                name: firstCarrier.title ?? "Неизвестный перевозчик",
                phone: firstCarrier.phone ?? "Телефон не указан",
                email: firstCarrier.email ?? "Email не указан",
                logoUrl: firstCarrier.logo ?? "Нет картинки"
            )
        } else {
            return TransitInfoModel(
                name: "Неизвестный перевозчик",
                phone: "Телефон не указан",
                email: "Email не указан",
                logoUrl: "Нет картинки"
            )
        }
    }
}
