import SwiftUI

struct WeatherView: View {
    @State private var forecasts: [WeatherList] = []
    private let weatherService = WeatherService()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    if !forecasts.isEmpty {
                        CurrentWeatherView(forecast: forecasts[0])
                            .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
                    }
                    
                    if forecasts.count > 1 {
                        FutureWeatherView(forecasts: Array(forecasts.dropFirst().prefix(7)))
                            .frame(maxWidth: .infinity)
                    }
                }
                .background(
                    LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .top, endPoint: .bottom)
                        .edgesIgnoringSafeArea(.all)
                )
                .navigationBarHidden(true)
                .onAppear {
                    weatherService.getWeatherInfo { fetchedWeather in
                        if let fetchedWeather = fetchedWeather {
                            self.forecasts = fetchedWeather.list
                        }
                    }
                }
            }
        }
    }
}

struct CurrentWeatherView: View {
    let forecast: WeatherList
    
    var body: some View {
        VStack {
            Text("Astana")
                .font(.largeTitle)
                .foregroundColor(.white)
            Text(formatCurrentDate())
                .font(.subheadline)
                .foregroundColor(.white)
            Image(systemName: "cloud.sun.fill")
                .font(.system(size: 64))
                .foregroundColor(.white)
            Text("\(String(format: "%.1f", forecast.main.temp))°C")
                .font(.system(size: 56))
                .fontWeight(.bold)
                .foregroundColor(.white)
            Text(forecast.weather.first?.description.capitalized ?? "")
                .font(.title3)
                .foregroundColor(.white)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color.purple.opacity(0.8))
        .cornerRadius(20)
        .shadow(radius: 4)
        .padding()
    }
    
    func formatCurrentDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, d MMMM yyyy"
        return dateFormatter.string(from: Date())
    }
}

struct FutureWeatherView: View {
    let forecasts: [WeatherList]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Future Weather")
                .font(.headline)
                .foregroundColor(.white)
                .padding()
            
            ForEach(forecasts.indices, id: \.self) { index in
                let forecast = forecasts[index]
                HStack {
                    VStack(alignment: .leading) {
                        Text(formatDate(dayIncrement: index + 1))
                            .font(.subheadline)
                            .foregroundColor(.white)
                        
                        Text("\(String(format: "%.1f", forecast.main.temp))°C")
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    Text(emoji(for: forecast.weather.first?.main ?? ""))
                        .font(.title)
                        .foregroundColor(.white)
                }
                .padding()
                .background(Color.blue.opacity(0.2))
                .cornerRadius(10)
                .padding(.horizontal)
                .padding(.vertical, 4)
            }
        }
        .background(Color.blue.opacity(0.4))
        .cornerRadius(20)
        .padding()
        .frame(maxWidth: .infinity)
    }
    
    func formatDate(dayIncrement: Int) -> String {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let forecastDate = calendar.date(byAdding: .day, value: dayIncrement, to: today) ?? today
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, d MMMM yyyy"
        return dateFormatter.string(from: forecastDate)
    }
    
    func emoji(for condition: String) -> String {
        switch condition.lowercased() {
        case "clear":
            return "☀️"
        case "clouds":
            return "☁️"
        case "rain":
            return "🌧"
        case "thunderstorm":
            return "⛈"
        case "snow":
            return "❄️"
        case "mist", "fog":
            return "🌫"
        case "wind":
            return "💨"
        default:
            return "❓"
        }
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView()
            .previewDevice("iPhone 13")
    }
}
