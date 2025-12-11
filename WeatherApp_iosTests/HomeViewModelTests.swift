//
//  HomeViewModelTests.swift
//  WeatherAppTests
//


import XCTest
@testable import WeatherApp_ios

// MARK: - HomeViewModelTests

@MainActor
final class HomeViewModelTests: XCTestCase {

    // MARK: - Properties
    var sut: HomeViewModel!
    var mockWeatherService: MockWeatherService!
    var mockPreferencesService: MockUserPreferencesService!

    // MARK: - Setup & Teardown
    override func setUp() {
        super.setUp()
        mockWeatherService = MockWeatherService()
        mockPreferencesService = MockUserPreferencesService()
        sut = HomeViewModel(
            weatherService: mockWeatherService,
            preferencesService: mockPreferencesService
        )
    }

    override func tearDown() {
        sut = nil
        mockWeatherService = nil
        mockPreferencesService = nil
        super.tearDown()
    }

    // MARK: - Test Cases
    /// Test initial state is idle
    func testInitialState_IsIdle() {
        // Then: Initial state should be idle
        XCTAssertEqual(sut.state, .idle)
    }

    /// Test successful weather fetching
    func testFetchWeather_Success() async {
        // Given: Mock weather data
        let mockData = WeatherData(
            cityName: "Paris",
            temperature: 22.0,
            feelsLike: 20.0,
            description: "Sunny",
            humidity: 60,
            pressure: 1015,
            windSpeed: 3.5,
            country: "FR"
        )
        mockWeatherService.mockWeatherData = mockData

        // Create expectation for state change
        let expectation = expectation(description: "State changes to loaded")
        var capturedStates: [HomeViewModel.State] = []

        sut.onStateChanged = { state in
            capturedStates.append(state)
            if case .loaded = state {
                expectation.fulfill()
            }
        }

        // When: Fetching weather
        sut.fetchWeather(for: "Paris")

        // Wait for async operation
        await fulfillment(of: [expectation], timeout: 2.0)

        // Then: Should transition through loading to loaded state
        XCTAssertEqual(mockWeatherService.fetchWeatherCallCount, 1)
        XCTAssertTrue(capturedStates.contains(.loading))

        if case .loaded(let weatherData) = sut.state {
            XCTAssertEqual(weatherData.cityName, "Paris")
            XCTAssertEqual(weatherData.temperature, 22.0)
        } else {
            XCTFail("Expected loaded state with weather data")
        }
    }

    /// Test weather fetching with empty city name
    func testFetchWeather_EmptyCity_ShowsError() {
        // Given: Empty city name
        var capturedState: HomeViewModel.State?
        sut.onStateChanged = { state in
            capturedState = state
        }

        // When: Fetching weather with empty city
        sut.fetchWeather(for: "")

        // Then: Should show error
        XCTAssertEqual(capturedState, .error(ErrorMessages.invalidCity))
        XCTAssertEqual(mockWeatherService.fetchWeatherCallCount, 0)
    }

    /// Test weather fetching with whitespace-only city name
    func testFetchWeather_WhitespaceCity_ShowsError() {
        // Given: Whitespace-only city name
        var capturedState: HomeViewModel.State?
        sut.onStateChanged = { state in
            capturedState = state
        }

        // When: Fetching weather
        sut.fetchWeather(for: "   ")

        // Then: Should show error
        XCTAssertEqual(capturedState, .error(ErrorMessages.invalidCity))
        XCTAssertEqual(mockWeatherService.fetchWeatherCallCount, 0)
    }

    /// Test weather fetching failure - city not found
    func testFetchWeather_CityNotFound_ShowsError() async {
        // Given: Service configured to throw city not found error
        mockWeatherService.shouldThrowError = true
        mockWeatherService.errorToThrow = .cityNotFound

        let expectation = expectation(description: "State changes to error")
        sut.onStateChanged = { state in
            if case .error = state {
                expectation.fulfill()
            }
        }

        // When: Fetching weather
        sut.fetchWeather(for: "InvalidCityName")

        // Wait for async operation
        await fulfillment(of: [expectation], timeout: 2.0)

        // Then: Should show error state
        if case .error(let message) = sut.state {
            XCTAssertEqual(message, NetworkError.cityNotFound.localizedDescription)
        } else {
            XCTFail("Expected error state")
        }
    }

    /// Test weather fetching failure - network error
    func testFetchWeather_NetworkError_ShowsError() async {
        // Given: Service configured to throw network error
        mockWeatherService.shouldThrowError = true
        mockWeatherService.errorToThrow = .networkUnavailable

        let expectation = expectation(description: "State changes to error")
        sut.onStateChanged = { state in
            if case .error = state {
                expectation.fulfill()
            }
        }

        // When: Fetching weather
        sut.fetchWeather(for: "London")

        // Wait for async operation
        await fulfillment(of: [expectation], timeout: 2.0)

        // Then: Should show error state
        if case .error(let message) = sut.state {
            XCTAssertEqual(message, NetworkError.networkUnavailable.localizedDescription)
        } else {
            XCTFail("Expected error state")
        }
    }

    /// Test saving favorite city
    func testSaveFavoriteCity() {
        // Given: A city name
        let cityName = "Tokyo"

        // When: Saving as favorite
        sut.saveFavoriteCity(cityName)

        // Then: Should save to preferences service
        XCTAssertEqual(mockPreferencesService.savedCity, cityName)
        XCTAssertEqual(mockPreferencesService.saveFavoriteCityCallCount, 1)
    }

    /// Test getting favorite city
    func testGetFavoriteCity() {
        // Given: A saved favorite city
        mockPreferencesService.savedCity = "Berlin"

        // When: Getting favorite city
        let favoriteCity = sut.getFavoriteCity()

        // Then: Should return saved city
        XCTAssertEqual(favoriteCity, "Berlin")
        XCTAssertEqual(mockPreferencesService.getFavoriteCityCallCount, 1)
    }

    /// Test getting favorite city when none exists
    func testGetFavoriteCity_WhenNoneExists() {
        // Given: No saved favorite city
        mockPreferencesService.savedCity = nil

        // When: Getting favorite city
        let favoriteCity = sut.getFavoriteCity()

        // Then: Should return nil
        XCTAssertNil(favoriteCity)
        XCTAssertEqual(mockPreferencesService.getFavoriteCityCallCount, 1)
    }

    /// Test clearing favorite city
    func testClearFavoriteCity() {
        // Given: A saved favorite city
        mockPreferencesService.savedCity = "Madrid"

        // When: Clearing favorite
        sut.clearFavoriteCity()

        // Then: Should clear from preferences
        XCTAssertNil(mockPreferencesService.savedCity)
        XCTAssertEqual(mockPreferencesService.clearFavoriteCityCallCount, 1)
    }

    /// Test resetting state
    func testResetState() {
        // Given: ViewModel in loaded state
        sut.state = .loaded(WeatherData(
            cityName: "Test",
            temperature: 20.0,
            feelsLike: 18.0,
            description: "Clear",
            humidity: 50,
            pressure: 1013,
            windSpeed: 5.0,
            country: "US"
        ))

        // When: Resetting state
        sut.resetState()

        // Then: Should return to idle
        XCTAssertEqual(sut.state, .idle)
    }
}
