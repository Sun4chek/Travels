import OpenAPIRuntime
import OpenAPIURLSession

typealias Carrier = Components.Schemas.CarrierResponse

protocol CarrierProtocol : Sendable {
    func getCarrier(code: String, system: String?) async throws -> Carrier
}

final class CarrierService: CarrierProtocol {
    
    private let client: Client
    private let apikey: String
    
    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }
    
    func getCarrier(code: String, system: String?) async throws -> Carrier {
        if let system {
            let response = try await client.getCarrierInfo(query: .init(apikey: apikey, code: code, system: system))
            return try response.ok.body.json
        } else {
            let response = try await client.getCarrierInfo(query: .init(apikey: apikey, code: code))
            return try response.ok.body.json
        }
    }
}

