import Foundation
import Combine

class WeatherService {
    private let apiKey = "4319abc20030811037552d2169dc04ed"
    private let baseUrl = "https://api.openweathermap.org/data/2.5/forecast"

    func fetchWeather() -> AnyPublisher<WeatherResponse, Error> {
        var components = URLComponents(string: baseUrl)!
        components.queryItems = [
            URLQueryItem(name: "lat", value: "51.169392"), // Coordinates for Astana
            URLQueryItem(name: "lon", value: "71.449074"),
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "cnt", value: "3"), 
            URLQueryItem(name: "appid", value: apiKey)
        ]

        let url = components.url!
        print("URL: \(url)") // Debug print

        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .handleEvents(receiveOutput: { data in
                let jsonString = String(data: data, encoding: .utf8)
                print("Response JSON: \(jsonString ?? "No Data")") // Debug print
            })
            .decode(type: WeatherResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
