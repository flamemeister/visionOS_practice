import Foundation
import Alamofire

class WeatherService {
    private let apiKey = "4319abc20030811037552d2169dc04ed"
    private let baseUrl = "https://api.openweathermap.org/data/2.5/forecast"
    
    func getWeatherInfo(completion: @escaping (Weather?) -> Void) {
        let parameters = [
            "lat": "51.1282205",
            "lon": "71.4306682",
            "units": "metric",
            "cnt": "7",
            "appid": apiKey
        ]
        
        AF.request(baseUrl, parameters: parameters).responseDecodable(of: Weather.self) { response in
            switch response.result {
            case .success(let result):
                DispatchQueue.main.async {
                    print("Weather data fetched: \(result)")
                    completion(result)
                }
            case .failure(let error):
                print("Failed to fetch weather data: \(error.localizedDescription)")
                completion(nil)
            }
        }
    }
}
