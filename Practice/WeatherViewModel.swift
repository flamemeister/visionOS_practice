import Foundation
import Combine

class WeatherViewModel: ObservableObject {
    @Published var currentWeather: CurrentWeather = CurrentWeather.empty
    @Published var weeklyWeather: [DailyWeather] = []
    private var cancellable: AnyCancellable?
    private let weatherService = WeatherService()

    func fetchWeather() {
        cancellable = weatherService.fetchWeather()
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                self.currentWeather = CurrentWeather(response: response.current)
                self.weeklyWeather = response.daily.map { DailyWeather(response: $0) }
            })
    }
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

    init(response: CurrentWeatherResponse) {
        self.date = DateFormatter.localizedString(from: Date(timeIntervalSince1970: TimeInterval(response.dt)), dateStyle: .full, timeStyle: .none)
        self.temperature = response.temp
        self.description = response.weather.first?.description ?? ""
        self.icon = response.weather.first?.icon ?? ""
    }

    static let empty = CurrentWeather(date: "", temperature: 0, description: "", icon: "")
}

struct DailyWeather: Identifiable {
    let id = UUID()
    let day: String
    let temp: Temperature
    let weather: [Weather]

    init(day: String, temp: Temperature, weather: [Weather]) {
        self.day = day
        self.temp = temp
        self.weather = weather
    }

    init(response: DailyWeatherResponse) {
        self.day = DateFormatter.localizedString(from: Date(timeIntervalSince1970: TimeInterval(response.dt)), dateStyle: .full, timeStyle: .none)
        self.temp = response.temp
        self.weather = response.weather
    }
}
