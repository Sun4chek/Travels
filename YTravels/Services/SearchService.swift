import OpenAPIRuntime
import OpenAPIURLSession

typealias Segments = Components.Schemas.Segments

protocol ScheduleBetweenStationsServiceProtocol: Sendable  {
    func getSchedule(from: String, to: String,transfers: Bool) async throws -> Segments
}

final class ScheduleBetweenStationsService: ScheduleBetweenStationsServiceProtocol {
    private let client: Client
    private let apikey: String
    
    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }
    
    func getSchedule(from: String, to: String, transfers: Bool = true) async throws -> Segments {
        let response = try await client.getSchedualBetweenStations(query: .init(
            apikey: apikey,
            from: from,
            to: to,
            transfers: transfers
        ))
        return try response.ok.body.json
    }
}
