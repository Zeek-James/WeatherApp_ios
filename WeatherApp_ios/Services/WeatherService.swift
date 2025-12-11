//
//  WeatherService.swift
//  WeatherApp
//
//  Concrete implementation of WeatherServiceProtocol.
//  Handles network requests to OpenWeather API using URLSession.
//  Uses async/await for modern, clean asynchronous code.
//

import Foundation

// MARK: - URLSessionProtocol
/// Protocol to abstract URLSession for testing
/// Allows injecting mock implementations
protocol URLSessionProtocol {
    func data(from url: URL) async throws -> (Data, URLResponse)
}

// MARK: - URLSession Conformance
/// Extend URLSession to conform to our protocol
extension URLSession: URLSessionProtocol {}

// MARK: - WeatherService
/// Concrete implementation of weather service using OpenWeather API
/// Uses URLSession for networking and modern async/await pattern
/// Follows Single Responsibility Principle - only handles weather data fetching
final class WeatherService: WeatherServiceProtocol {

    // MARK: - Properties
    private let urlSession: URLSessionProtocol

    // MARK: - Initialization
    /// Initializes weather service with dependency injection
    /// - Parameter urlSession: URLSession instance (injectable for testing)
    /// This demonstrates Dependency Injection - URLSession is injected rather than hardcoded
    init(urlSession: URLSessionProtocol = URLSession.shared) {
        self.urlSession = urlSession
    }

    // MARK: - WeatherServiceProtocol Implementation
    /// Fetches weather data from OpenWeather API
    /// - Parameter city: City name to fetch weather for
    /// - Returns: WeatherData domain model
    /// - Throws: NetworkError with specific error cases
    func fetchWeather(for city: String) async throws -> WeatherData {
        // Step 1: Construct URL with query parameters
        guard let url = buildURL(for: city) else {
            throw NetworkError.invalidURL
        }

        // Step 2: Perform network request
        let (data, response) = try await urlSession.data(from: url)

        // Step 3: Validate HTTP response
        try validateResponse(response)

        // Step 4: Decode JSON response
        let weatherResponse = try decodeResponse(data)

        // Step 5: Convert API model to domain model
        return WeatherData.from(response: weatherResponse)
    }

    // MARK: - Private Helper Methods
    /// Builds the URL for OpenWeather API request
    /// - Parameter city: City name
    /// - Returns: Constructed URL or nil if invalid
    private func buildURL(for city: String) -> URL? {
        var components = URLComponents(string: APIConstants.baseURL)
        components?.queryItems = [
            URLQueryItem(name: "q", value: city),
            URLQueryItem(name: "appid", value: APIConstants.apiKey),
            URLQueryItem(name: "units", value: APIConstants.units)
        ]
        return components?.url
    }

    /// Validates HTTP response status code
    /// - Parameter response: URLResponse from the request
    /// - Throws: NetworkError based on status code
    private func validateResponse(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.unknown(NSError(domain: "InvalidResponse", code: -1))
        }

        switch httpResponse.statusCode {
        case 200...299:
            // Success - no error
            return
        case 401:
            throw NetworkError.unauthorized
        case 404:
            throw NetworkError.cityNotFound
        case 500...599:
            throw NetworkError.serverError(statusCode: httpResponse.statusCode)
        default:
            throw NetworkError.serverError(statusCode: httpResponse.statusCode)
        }
    }

    /// Decodes JSON data into WeatherResponse model
    /// - Parameter data: Raw JSON data
    /// - Returns: Decoded WeatherResponse
    /// - Throws: NetworkError.decodingError if parsing fails
    private func decodeResponse(_ data: Data) throws -> WeatherResponse {
        let decoder = JSONDecoder()
        do {
            return try decoder.decode(WeatherResponse.self, from: data)
        } catch {
            print("❌ Decoding error: \(error)")
            // For debugging: print raw JSON
            if let jsonString = String(data: data, encoding: .utf8) {
                print("📄 Raw JSON: \(jsonString)")
            }
            throw NetworkError.decodingError
        }
    }
}
