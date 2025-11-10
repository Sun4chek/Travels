import OpenAPIRuntime
import OpenAPIURLSession

final class YandexRaspAPI {
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
    
    func getScheduleBetweenStations(from: String, to: String, date: String?) async throws -> Segments {
        try await scheduleBetweenStationsService.getSchedule(from: from, to: to)
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

