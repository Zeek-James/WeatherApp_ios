//
//  WeatherResponse.swift
//  WeatherApp
//
//  Model representing the OpenWeather API response structure.
//  Follows Codable protocol for automatic JSON parsing.
//

import Foundation

// MARK: - WeatherResponse
/// Root response object from OpenWeather Current Weather API
/// Conforms to Codable for JSON decoding and Equatable for testing
struct WeatherResponse: Codable, Equatable {
    let coord: Coordinate?
    let weather: [WeatherInfo]
    let base: String?
    let main: MainWeatherData
    let visibility: Int?
    let wind: Wind?
    let clouds: Clouds?
    let dt: Int
    let sys: Sys?
    let timezone: Int?
    let id: Int
    let name: String
    let cod: Int

    // MARK: - Coordinate
    struct Coordinate: Codable, Equatable {
        let lon: Double
        let lat: Double
    }

    // MARK: - WeatherInfo
    /// Contains weather condition information (description, icon, etc.)
    struct WeatherInfo: Codable, Equatable {
        let id: Int
        let main: String
        let description: String
        let icon: String
    }

    // MARK: - MainWeatherData
    /// Primary weather data including temperature, pressure, humidity
    struct MainWeatherData: Codable, Equatable {
        let temp: Double
        let feelsLike: Double
        let tempMin: Double
        let tempMax: Double
        let pressure: Int
        let humidity: Int

        enum CodingKeys: String, CodingKey {
            case temp
            case feelsLike = "feels_like"
            case tempMin = "temp_min"
            case tempMax = "temp_max"
            case pressure
            case humidity
        }
    }

    // MARK: - Wind
    struct Wind: Codable, Equatable {
        let speed: Double
        let deg: Int?
        let gust: Double?
    }

    // MARK: - Clouds
    struct Clouds: Codable, Equatable {
        let all: Int
    }

    // MARK: - Sys
    struct Sys: Codable, Equatable {
        let type: Int?
        let id: Int?
        let country: String?
        let sunrise: Int?
        let sunset: Int?
    }
}
