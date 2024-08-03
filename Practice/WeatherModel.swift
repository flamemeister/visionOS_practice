////
////  WeatherModel.swift
////  Practice
////
////  Created by Aldiyar Saken on 03.08.2024.
////
//
//import Foundation
//
//struct WeatherResponse: Codable {
//    let current: CurrentWeatherResponse
//    let daily: [DailyWeather]
//}
//
//struct DailyWeather: Codable, Identifiable {
//    let id = UUID()
//    let dt: Int
//    let temp: Temperature
//    let weather: [Weather]
//
//    var day: String {
//        let date = Date(timeIntervalSince1970: TimeInterval(dt))
//        let formatter = DateFormatter()
//        formatter.dateFormat = "EEEE"
//        return formatter.string(from: date)
//    }
//}
//
//struct CurrentWeatherResponse: Codable {
//    let dt: Int
//    let temp: Double
//    let weather: [Weather]
//}
//
//struct Temperature: Codable {
//    let day: Double
//}
//
//struct Weather: Codable {
//    let description: String
//    let icon: String
//}
