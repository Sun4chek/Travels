//
//  APIProvider.swift
//  YTravels
//
//  Created by Волошин Александр on 12/10/25.
//

// APIProvider.swift
import Foundation
import OpenAPIURLSession



final class APIProvider {
    static let shared = APIProvider()
    
    let yandexRasp: YandexRaspAPI
    
    private init() {
        do {
            let client = Client(
                serverURL: try Servers.Server1.url(),
                transport: URLSessionTransport()
            )
            self.yandexRasp = YandexRaspAPI(
                client: client,
                apikey: "dce6cc09-08b9-49c0-a4d3-77bddb427cd1" // Позже вынеси в конфиг!
            )
        } catch {
            fatalError("Не удалось создать YandexRaspAPI: \(error)")
            // В продакшене лучше сделать мягкую заглушку
        }
    }
}
