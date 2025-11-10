import SwiftUI
import OpenAPIURLSession

struct ContentView: View {
    var apikey = "dce6cc09-08b9-49c0-a4d3-77bddb427cd1"
    
    private let api: YandexRaspAPI
    
    // MARK: - Init
    init() {
        do {
            let client = Client(
                serverURL: try Servers.Server1.url(),
                transport: URLSessionTransport()
            )
            self.api = YandexRaspAPI(
                client: client,
                apikey: "dce6cc09-08b9-49c0-a4d3-77bddb427cd1"
            )
        } catch {
            fatalError("Ошибка инициализации клиента: \(error)")
        }
    }
    
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
        .onAppear{
            
            Task{
                //                await testNearestStations()
                //                await testScheduleBetweenStations()
                //                await testStationSchedule()
                //                await testRouteStation()
                //                await testNearestCity()
                //                await testCarrierInfo()
                //                await testAllStations()
                //                await testCopyright()
                
            }
        }
    }
}

#Preview {
    ContentView()
    
}


extension ContentView {
    func testNearestStations() async {
        do {
            let result = try await api.getNearestStations(lat: 59.864177, lng: 59.864177, distance: 50)
            print("✅ Nearest stations: \(result)")
        } catch {
            print("❌ Error fetching nearest stations: \(error)")
        }
    }
    
    func testScheduleBetweenStations() async {
        do {
            let result = try await api.getScheduleBetweenStations(from: "c146", to: "c213", date: nil)
            print("✅ Schedule between stations: \(result)")
        } catch {
            print("❌ Error fetching schedule: \(error)")
        }
    }
    
    func testStationSchedule() async {
        do {
            let result = try await api.getStationSchedule(station: "s9602496", date: nil)
            print("✅ Station schedule: \(result)")
        } catch {
            print("❌ Error fetching station schedule: \(error)")
        }
    }
    
    func testRouteStation() async {
        do {
            let result = try await api.getRouteStation(uid: "078S_9_2")
            print("✅ Route stations: \(result)")
        } catch {
            print("❌ Error fetching route stations: \(error)")
        }
    }
    
    func testNearestCity() async {
        do {
            let result = try await api.getNearestSettlement(lat: 59.864177, lng: 30.319163)
            print("✅ Nearest city: \(result)")
        } catch {
            print("❌ Error fetching nearest city: \(error)")
        }
    }
    
    func testCarrierInfo() async {
        do {
            let result = try await api.getCarrierInfo(code: "680",system: nil)
            print("✅ Carrier info: \(result)")
        } catch {
            print("❌ Error fetching carrier info: \(error)")
        }
    }
    
    func testAllStations() async {
        do {
            let result = try await api.getAllStations()
            print("✅ All stations: \(result)")
        } catch {
            print("❌ Error fetching all stations: \(error)")
        }
    }
    
    func testCopyright() async {
        do {
            let result = try await api.getCopyright()
            print("✅ Copyright: \(result)")
        } catch {
            print("❌ Error fetching copyright: \(error)")
        }
    }
}
