import OpenAPIRuntime
import Foundation
import OpenAPIURLSession

typealias Copyright = Components.Schemas.Copyright

typealias CopyrightResponse = Components.Schemas.CopyrightResponse

protocol CopyrightServiceProtocol {
    func getCopyright() async throws -> CopyrightResponse
}

final class CopyrightService: CopyrightServiceProtocol {
    private let client: Client
    private let apikey: String
    
    init(client: Client, apikey: String) {
        self.client = client
        self.apikey = apikey
    }
    
    func getCopyright() async throws -> CopyrightResponse {
        let response = try await client.copyRight(
            query: .init(apikey: apikey)
        )
        return try response.ok.body.json
    }
    
}

