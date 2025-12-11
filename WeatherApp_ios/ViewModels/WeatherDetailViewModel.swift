//
//  WeatherDetailViewModel.swift
//  WeatherApp
//

import Foundation

final class WeatherDetailViewModel {

    private let weatherData: WeatherData

    var cityName: String {
        weatherData.location
    }

    var temperature: String {
        weatherData.temperatureString
    }

    var feelsLike: String {
        "Feels like \(weatherData.feelsLikeString)"
    }

    var description: String {
        weatherData.capitalizedDescription
    }

    var humidity: String {
        "Humidity: \(weatherData.humidity)%"
    }

    var pressure: String {
        "Pressure: \(weatherData.pressure) hPa"
    }

    var windSpeed: String {
        String(format: "Wind: %.1f m/s", weatherData.windSpeed)
    }

    init(weatherData: WeatherData) {
        self.weatherData = weatherData
    }

    func getWeatherData() -> WeatherData {
        return weatherData
    }
}
