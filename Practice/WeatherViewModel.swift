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
                if let first = response.list.first {
                    self.currentWeather = CurrentWeather(response: first)
                }
                
                let groupedByDay = Dictionary(grouping: response.list) { (forecast) -> String in
                    let date = Date(timeIntervalSince1970: TimeInterval(forecast.dt))
                    return DateFormatter.localizedString(from: date, dateStyle: .full, timeStyle: .none)
                }
                
                self.weeklyWeather = groupedByDay.compactMap { (key, value) -> DailyWeather? in
                    guard let firstForecast = value.first else { return nil }
                    let avgTemp = value.map { $0.main.temp }.reduce(0, +) / Double(value.count)
                    return DailyWeather(day: key, temp: avgTemp, weather: firstForecast.weather)
                }
                .sorted { $0.day < $1.day }
            })
    }
}
