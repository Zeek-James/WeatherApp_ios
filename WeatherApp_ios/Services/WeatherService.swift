//
//  WeatherService.swift
//  WeatherApp
//

import Foundation

protocol URLSessionProtocol {
    func data(from url: URL) async throws -> (Data, URLResponse)
}

extension URLSession: URLSessionProtocol {}

final class WeatherService: WeatherServiceProtocol {

    private let urlSession: URLSessionProtocol

    init(urlSession: URLSessionProtocol = URLSession.shared) {
        self.urlSession = urlSession
    }

    func fetchWeather(for city: String) async throws -> WeatherData {
        guard let url = buildURL(for: city) else {
            throw NetworkError.invalidURL
        }

        let (data, response) = try await urlSession.data(from: url)
        try validateResponse(response)
        let weatherResponse = try decodeResponse(data)
        return WeatherData.from(response: weatherResponse)
    }

    private func buildURL(for city: String) -> URL? {
        var components = URLComponents(string: APIConstants.baseURL)
        components?.queryItems = [
            URLQueryItem(name: "q", value: city),
            URLQueryItem(name: "appid", value: APIConstants.apiKey),
            URLQueryItem(name: "units", value: APIConstants.units)
        ]
        return components?.url
    }

    private func validateResponse(_ response: URLResponse) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.unknown(NSError(domain: "InvalidResponse", code: -1))
        }

        switch httpResponse.statusCode {
        case 200...299:
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

    private func decodeResponse(_ data: Data) throws -> WeatherResponse {
        let decoder = JSONDecoder()
        do {
            return try decoder.decode(WeatherResponse.self, from: data)
        } catch {
            print("Decoding error: \(error)")
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Raw JSON: \(jsonString)")
            }
            throw NetworkError.decodingError
        }
    }
}
