//
//  WeatherServiceProtocol.swift
//  WeatherApp
//
import Foundation

// MARK: - WeatherServiceProtocol
protocol WeatherServiceProtocol {
    func fetchWeather(for city: String) async throws -> WeatherData
}
