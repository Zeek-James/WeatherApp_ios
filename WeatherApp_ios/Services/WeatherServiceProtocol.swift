//
//  WeatherServiceProtocol.swift
//  WeatherApp
//
//  Protocol defining weather service contract.
//  Using protocols follows the Dependency Inversion Principle (SOLID) -
//  high-level modules depend on abstractions, not concrete implementations.
//  This enables easy testing via mocking and allows for different implementations.
//

import Foundation

// MARK: - WeatherServiceProtocol
/// Protocol defining the contract for weather data fetching
/// Benefits:
/// 1. Dependency Inversion - ViewModels depend on abstraction, not concrete implementation
/// 2. Testability - Easy to create mock implementations for unit tests
/// 3. Flexibility - Can swap implementations (e.g., different API providers)
protocol WeatherServiceProtocol {
    /// Fetches weather data for a given city
    /// - Parameter city: The name of the city to fetch weather for
    /// - Returns: WeatherData containing current weather information
    /// - Throws: NetworkError if the request fails
    func fetchWeather(for city: String) async throws -> WeatherData
}
