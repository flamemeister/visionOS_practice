import Foundation

struct WeatherResponse: Codable {
    let list: [Forecast]
}

struct Forecast: Codable {
    let dt: Int
    let main: Main
    let weather: [Weather]
}

struct Main: Codable {
    let temp: Double
}

struct Weather: Codable {
    let description: String
    let icon: String
}

struct CurrentWeather {
    let date: String
    let temperature: Double
    let description: String
    let icon: String

    init(date: String, temperature: Double, description: String, icon: String) {
        self.date = date
        self.temperature = temperature
        self.description = description
        self.icon = icon
    }

    init(response: Forecast) {
        self.date = DateFormatter.localizedString(from: Date(timeIntervalSince1970: TimeInterval(response.dt)), dateStyle: .full, timeStyle: .none)
        self.temperature = response.main.temp
        self.description = response.weather.first?.description ?? ""
        self.icon = response.weather.first?.icon ?? ""
    }

    static let empty = CurrentWeather(date: "", temperature: 0, description: "", icon: "")
}

struct DailyWeather: Identifiable {
    let id = UUID()
    let day: String
    let temp: Double
    let weather: [Weather]

    init(day: String, temp: Double, weather: [Weather]) {
        self.day = day
        self.temp = temp
        self.weather = weather
    }
}
