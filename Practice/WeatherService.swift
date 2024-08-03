import Foundation
import Combine

class WeatherService {
    private let apiKey = "4319abc20030811037552d2169dc04ed"
    private let baseUrl = "https://api.openweathermap.org/data/2.5/onecall"

    func fetchWeather() -> AnyPublisher<WeatherResponse, Error> {
        var components = URLComponents(string: baseUrl)!
        components.queryItems = [
            URLQueryItem(name: "lat", value: "51.169392"),
            URLQueryItem(name: "lon", value: "71.449074"),
            URLQueryItem(name: "exclude", value: "minutely,hourly,alerts"),
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "appid", value: apiKey)
        ]

        let url = components.url!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: WeatherResponse.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

struct WeatherResponse: Codable {
    let current: CurrentWeatherResponse
    let daily: [DailyWeatherResponse]
}

struct CurrentWeatherResponse: Codable {
    let dt: Int
    let temp: Double
    let weather: [Weather]
}

struct DailyWeatherResponse: Codable {
    let dt: Int
    let temp: Temperature
    let weather: [Weather]
}

struct Temperature: Codable {
    let day: Double
}

struct Weather: Codable {
    let description: String
    let icon: String
}
