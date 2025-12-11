//
//  MockURLSession.swift
//  WeatherAppTests
//


import Foundation
@testable import WeatherApp_ios

// MARK: - MockURLSession

class MockURLSession: URLSessionProtocol {

    // MARK: - Properties
    var mockData: Data?
    var mockResponse: URLResponse?
    var mockError: Error?

    // MARK: - URLSessionProtocol Implementation
    func data(from url: URL) async throws -> (Data, URLResponse) {
        // If error is set, throw it
        if let error = mockError {
            throw error
        }

        // Return mock data and response
        let data = mockData ?? Data()
        let response = mockResponse ?? HTTPURLResponse(
            url: url,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!

        return (data, response)
    }
}

// MARK: - MockWeatherService
/// Mock WeatherService for testing ViewModels
class MockWeatherService: WeatherServiceProtocol {

    // MARK: - Properties
    var shouldThrowError = false
    var errorToThrow: NetworkError = .cityNotFound
    var mockWeatherData: WeatherData?
    var fetchWeatherCallCount = 0

    // MARK: - WeatherServiceProtocol Implementation
    func fetchWeather(for city: String) async throws -> WeatherData {
        fetchWeatherCallCount += 1

        if shouldThrowError {
            throw errorToThrow
        }

        if let mockData = mockWeatherData {
            return mockData
        }

        // Return default mock data
        return WeatherData(
            cityName: city,
            temperature: 20.0,
            feelsLike: 18.0,
            description: "Clear sky",
            humidity: 50,
            pressure: 1013,
            windSpeed: 5.0,
            country: "US"
        )
    }
}

// MARK: - MockUserPreferencesService
/// Mock UserPreferencesService for testing
class MockUserPreferencesService: UserPreferencesServiceProtocol {

    // MARK: - Properties
    var savedCity: String?
    var saveFavoriteCityCallCount = 0
    var getFavoriteCityCallCount = 0
    var clearFavoriteCityCallCount = 0

    // MARK: - UserPreferencesServiceProtocol Implementation
    func saveFavoriteCity(_ city: String) {
        savedCity = city
        saveFavoriteCityCallCount += 1
    }

    func getFavoriteCity() -> String? {
        getFavoriteCityCallCount += 1
        return savedCity
    }

    func clearFavoriteCity() {
        savedCity = nil
        clearFavoriteCityCallCount += 1
    }
}
