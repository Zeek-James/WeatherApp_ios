//
//  WeatherData.swift
//  WeatherApp
//

import Foundation

// MARK: - WeatherData
struct WeatherData: Equatable {
    let cityName: String
    let temperature: Double
    let feelsLike: Double
    let description: String
    let humidity: Int
    let pressure: Int
    let windSpeed: Double
    let country: String?

    /// Format temperature with degree symbol
    var temperatureString: String {
        return String(format: "%.1f°C", temperature)
    }

    /// Format feels like temperature
    var feelsLikeString: String {
        return String(format: "%.1f°C", feelsLike)
    }

    /// Capitalize weather description
    var capitalizedDescription: String {
        return description.capitalized
    }

    /// Location display
    var location: String {
        if let country = country {
            return "\(cityName), \(country)"
        }
        return cityName
    }
}

// MARK: - Mapping Extension
extension WeatherData {
 
    static func from(response: WeatherResponse) -> WeatherData {
        return WeatherData(
            cityName: response.name,
            temperature: response.main.temp,
            feelsLike: response.main.feelsLike,
            description: response.weather.first?.description ?? "N/A",
            humidity: response.main.humidity,
            pressure: response.main.pressure,
            windSpeed: response.wind?.speed ?? 0.0,
            country: response.sys?.country
        )
    }
}
