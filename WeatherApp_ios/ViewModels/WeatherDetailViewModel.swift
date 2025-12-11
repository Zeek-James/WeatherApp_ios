//
//  WeatherDetailViewModel.swift
//  WeatherApp
//
//  ViewModel for the Weather Detail screen.
//  Handles presentation logic for displaying weather information.
//  Demonstrates MVVM separation of concerns.
//

import Foundation

// MARK: - WeatherDetailViewModel
/// ViewModel for weather detail screen
/// Responsibilities:
/// - Hold weather data for display
/// - Format data for presentation
/// - Could be extended for additional features (refresh, share, etc.)
final class WeatherDetailViewModel {

    // MARK: - Properties
    private let weatherData: WeatherData

    /// Formatted properties for UI display
    /// These computed properties encapsulate formatting logic
    /// keeping the view layer clean and testable
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

    // MARK: - Initialization
    /// Initializes with weather data
    /// - Parameter weatherData: The weather data to display
    init(weatherData: WeatherData) {
        self.weatherData = weatherData
    }

    // MARK: - Public Methods
    /// Returns the raw weather data (useful for passing to other screens)
    /// - Returns: The underlying WeatherData model
    func getWeatherData() -> WeatherData {
        return weatherData
    }

    /// Could add methods for:
    /// - Refreshing weather data
    /// - Sharing weather information
    /// - Converting temperature units
    /// - etc.
}
