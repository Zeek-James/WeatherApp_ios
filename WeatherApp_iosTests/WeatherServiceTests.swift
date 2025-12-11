//
//  WeatherServiceTests.swift
//  WeatherAppTests
//

import XCTest
@testable import WeatherApp_ios

// MARK: - WeatherServiceTests

final class WeatherServiceTests: XCTestCase {

    // MARK: - Properties
    var sut: WeatherService!
    var mockURLSession: MockURLSession!

    // MARK: - Setup & Teardown
    override func setUp() {
        super.setUp()
        mockURLSession = MockURLSession()
        sut = WeatherService(urlSession: mockURLSession)
    }

    override func tearDown() {
        sut = nil
        mockURLSession = nil
        super.tearDown()
    }

    // MARK: - Test Cases
    /// Test successful weather data fetching
    func testFetchWeather_Success() async throws {
        // Given: Valid weather API response
        let mockResponse = createMockWeatherResponse()
        mockURLSession.mockData = try JSONEncoder().encode(mockResponse)
        mockURLSession.mockResponse = HTTPURLResponse(
            url: URL(string: "https://api.openweathermap.org")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )

        // When: Fetching weather for a city
        let result = try await sut.fetchWeather(for: "London")

        // Then: Should return valid weather data
        XCTAssertEqual(result.cityName, "London")
        XCTAssertEqual(result.temperature, 20.0)
        XCTAssertEqual(result.description, "clear sky")
        XCTAssertEqual(result.humidity, 65)
    }

    /// Test city not found (404) error
    func testFetchWeather_CityNotFound() async {
        // Given: 404 response
        mockURLSession.mockData = Data()
        mockURLSession.mockResponse = HTTPURLResponse(
            url: URL(string: "https://api.openweathermap.org")!,
            statusCode: 404,
            httpVersion: nil,
            headerFields: nil
        )

        // When/Then: Should throw cityNotFound error
        do {
            _ = try await sut.fetchWeather(for: "InvalidCity")
            XCTFail("Should have thrown cityNotFound error")
        } catch let error as NetworkError {
            XCTAssertEqual(error, NetworkError.cityNotFound)
        } catch {
            XCTFail("Wrong error type thrown: \(error)")
        }
    }

    /// Test unauthorized (401) error - invalid API key
    func testFetchWeather_Unauthorized() async {
        // Given: 401 response
        mockURLSession.mockResponse = HTTPURLResponse(
            url: URL(string: "https://api.openweathermap.org")!,
            statusCode: 401,
            httpVersion: nil,
            headerFields: nil
        )

        // When/Then: Should throw unauthorized error
        do {
            _ = try await sut.fetchWeather(for: "London")
            XCTFail("Should have thrown unauthorized error")
        } catch let error as NetworkError {
            XCTAssertEqual(error, NetworkError.unauthorized)
        } catch {
            XCTFail("Wrong error type thrown: \(error)")
        }
    }

    /// Test server error (500) handling
    func testFetchWeather_ServerError() async {
        // Given: 500 response
        mockURLSession.mockResponse = HTTPURLResponse(
            url: URL(string: "https://api.openweathermap.org")!,
            statusCode: 500,
            httpVersion: nil,
            headerFields: nil
        )

        // When/Then: Should throw serverError
        do {
            _ = try await sut.fetchWeather(for: "London")
            XCTFail("Should have thrown server error")
        } catch let error as NetworkError {
            if case .serverError(let statusCode) = error {
                XCTAssertEqual(statusCode, 500)
            } else {
                XCTFail("Wrong error case: \(error)")
            }
        } catch {
            XCTFail("Wrong error type thrown: \(error)")
        }
    }

    /// Test decoding error with invalid JSON
    func testFetchWeather_DecodingError() async {
        // Given: Invalid JSON data
        mockURLSession.mockData = Data("Invalid JSON".utf8)
        mockURLSession.mockResponse = HTTPURLResponse(
            url: URL(string: "https://api.openweathermap.org")!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )

        // When/Then: Should throw decodingError
        do {
            _ = try await sut.fetchWeather(for: "London")
            XCTFail("Should have thrown decoding error")
        } catch let error as NetworkError {
            XCTAssertEqual(error, NetworkError.decodingError)
        } catch {
            XCTFail("Wrong error type thrown: \(error)")
        }
    }

    // MARK: - Helper Methods
    /// Creates a mock WeatherResponse for testing
    private func createMockWeatherResponse() -> WeatherResponse {
        return WeatherResponse(
            coord: WeatherResponse.Coordinate(lon: -0.13, lat: 51.51),
            weather: [
                WeatherResponse.WeatherInfo(
                    id: 800,
                    main: "Clear",
                    description: "clear sky",
                    icon: "01d"
                )
            ],
            base: "stations",
            main: WeatherResponse.MainWeatherData(
                temp: 20.0,
                feelsLike: 19.0,
                tempMin: 18.0,
                tempMax: 22.0,
                pressure: 1013,
                humidity: 65
            ),
            visibility: 10000,
            wind: WeatherResponse.Wind(speed: 5.5, deg: 230, gust: nil),
            clouds: WeatherResponse.Clouds(all: 0),
            dt: 1234567890,
            sys: WeatherResponse.Sys(
                type: 1,
                id: 1234,
                country: "GB",
                sunrise: 1234560000,
                sunset: 1234590000
            ),
            timezone: 0,
            id: 2643743,
            name: "London",
            cod: 200
        )
    }
}
