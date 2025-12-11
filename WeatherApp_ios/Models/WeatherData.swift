//
//  WeatherData.swift
//  WeatherApp
//
//  Domain model representing weather data used throughout the app.
//  This is separate from the API response model (WeatherResponse) following
//  the Separation of Concerns principle - API models are for parsing,
//  domain models are for business logic.
//

import Foundation

// MARK: - WeatherData
/// Simplified weather data model used in the app's business logic layer
/// Separating domain models from API models allows for easier testing and
/// protects the app from API changes (Single Responsibility Principle)
struct WeatherData: Equatable {
    let cityName: String
    let temperature: Double
    let feelsLike: Double
    let description: String
    let humidity: Int
    let pressure: Int
    let windSpeed: Double
    let country: String?

    /// Computed property to format temperature with degree symbol
    var temperatureString: String {
        return String(format: "%.1f°C", temperature)
    }

    /// Computed property to format feels like temperature
    var feelsLikeString: String {
        return String(format: "%.1f°C", feelsLike)
    }

    /// Computed property to capitalize weather description
    var capitalizedDescription: String {
        return description.capitalized
    }

    /// Computed property for location display
    var location: String {
        if let country = country {
            return "\(cityName), \(country)"
        }
        return cityName
    }
}

// MARK: - Mapping Extension
extension WeatherData {
    /// Maps API response to domain model
    /// This follows the Adapter pattern - converting external API format to internal domain format
    /// - Parameter response: The API response from OpenWeather
    /// - Returns: Domain model WeatherData
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
