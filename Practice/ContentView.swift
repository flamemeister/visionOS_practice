import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = WeatherViewModel()

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.purple, .blue]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                CurrentWeatherView(currentWeather: $viewModel.currentWeather)
                    .padding()
                
                WeeklyWeatherView(weeklyWeather: $viewModel.weeklyWeather)
                    .padding()
                
                Spacer()
            }
        }
        .onAppear {
            viewModel.fetchWeather()
        }
    }
}

struct CurrentWeatherView: View {
    @Binding var currentWeather: CurrentWeather
    
    var body: some View {
        VStack {
            Text("Astana")
                .font(.largeTitle)
                .foregroundColor(.white)
                .padding(.top)
            
            Text(currentWeather.date)
                .foregroundColor(.white)
                .padding(.bottom)
            
            Image(systemName: "sun.max.fill") 
                .resizable()
                .frame(width: 100, height: 100)
                .foregroundColor(.white)
            
            Text("\(currentWeather.temperature, specifier: "%.1f")°C")
                .font(.system(size: 70))
                .foregroundColor(.white)
                .bold()
            
            Text(currentWeather.description)
                .foregroundColor(.white)
        }
    }
}

struct WeeklyWeatherView: View {
    @Binding var weeklyWeather: [DailyWeather]
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Future Weather")
                .font(.title2)
                .foregroundColor(.white)
                .padding(.bottom, 10)
            
            ForEach(weeklyWeather) { dayWeather in
                HStack {
                    Text(dayWeather.day)
                        .foregroundColor(.white)
                    
                    Spacer()
                    
                    Text("\(Int(dayWeather.temp))°C")
                        .foregroundColor(.white)
                    
                    Image(systemName: "sun.max.fill") // Use a default icon for now
                        .foregroundColor(.white)
                }
                .padding(.vertical, 5)
            }
        }
        .padding()
        .background(Color.white.opacity(0.2))
        .cornerRadius(10)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
