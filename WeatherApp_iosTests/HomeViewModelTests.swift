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

    func testFetchWeather_EmptyCity_ShowsError() {
        // Given: Empty city name
        var capturedState: HomeViewModel.State?
        sut.onStateChanged = { state in
            capturedState = state
        }

        sut.fetchWeather(for: "")

        // Then: Should show error
        XCTAssertEqual(capturedState, .error(ErrorMessages.invalidCity))
        XCTAssertEqual(mockWeatherService.fetchWeatherCallCount, 0)
    }

    func testFetchWeather_WhitespaceCity_ShowsError() {
        // Given: Whitespace-only city name
        var capturedState: HomeViewModel.State?
        sut.onStateChanged = { state in
            capturedState = state
        }

        sut.fetchWeather(for: "   ")

        XCTAssertEqual(capturedState, .error(ErrorMessages.invalidCity))
        XCTAssertEqual(mockWeatherService.fetchWeatherCallCount, 0)
    }

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


        sut.fetchWeather(for: "InvalidCityName")


        await fulfillment(of: [expectation], timeout: 2.0)

        if case .error(let message) = sut.state {
            XCTAssertEqual(message, NetworkError.cityNotFound.localizedDescription)
        } else {
            XCTFail("Expected error state")
        }
    }

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

        sut.fetchWeather(for: "London")

        await fulfillment(of: [expectation], timeout: 2.0)

        if case .error(let message) = sut.state {
            XCTAssertEqual(message, NetworkError.networkUnavailable.localizedDescription)
        } else {
            XCTFail("Expected error state")
        }
    }

    func testSaveFavoriteCity_AfterSuccessfulSearch() async {
        // Given: A successful weather fetch
        let cityName = "Tokyo"
        let mockData = WeatherData(
            cityName: cityName,
            temperature: 25.0,
            feelsLike: 24.0,
            description: "Clear",
            humidity: 65,
            pressure: 1010,
            windSpeed: 2.5,
            country: "JP"
        )
        mockWeatherService.mockWeatherData = mockData

        let expectation = expectation(description: "State changes to loaded")
        sut.onStateChanged = { state in
            if case .loaded = state {
                expectation.fulfill()
            }
        }

        sut.fetchWeather(for: cityName)
        await fulfillment(of: [expectation], timeout: 2.0)

        let result = sut.saveFavoriteCity()

        XCTAssertTrue(result)
        XCTAssertEqual(mockPreferencesService.savedCity, cityName)
        XCTAssertEqual(mockPreferencesService.saveFavoriteCityCallCount, 1)
    }

    func testSaveFavoriteCity_WithoutSearch_ReturnsFalse() {
        // Given: No prior search

        let result = sut.saveFavoriteCity()

        XCTAssertFalse(result)
        XCTAssertEqual(mockPreferencesService.saveFavoriteCityCallCount, 0)
    }

    func testCanSaveFavorite_AfterSuccessfulSearch() async {
        // Given: A successful weather fetch
        let mockData = WeatherData(
            cityName: "Paris",
            temperature: 18.0,
            feelsLike: 16.0,
            description: "Cloudy",
            humidity: 70,
            pressure: 1012,
            windSpeed: 4.0,
            country: "FR"
        )
        mockWeatherService.mockWeatherData = mockData

        let expectation = expectation(description: "State changes to loaded")
        sut.onStateChanged = { state in
            if case .loaded = state {
                expectation.fulfill()
            }
        }

        sut.fetchWeather(for: "Paris")
        await fulfillment(of: [expectation], timeout: 2.0)

        // When: Checking if can save favorite
        let canSave = sut.canSaveFavorite()

        // Then: Should return true
        XCTAssertTrue(canSave)
    }

    func testCanSaveFavorite_WithoutSearch_ReturnsFalse() {

        let canSave = sut.canSaveFavorite()

        XCTAssertFalse(canSave)
    }

    func testGetFavoriteCity() {
        mockPreferencesService.savedCity = "Berlin"

        let favoriteCity = sut.getFavoriteCity()

        XCTAssertEqual(favoriteCity, "Berlin")
        XCTAssertEqual(mockPreferencesService.getFavoriteCityCallCount, 1)
    }

    func testGetFavoriteCity_WhenNoneExists() {
        // Given: No saved favorite city
        mockPreferencesService.savedCity = nil

        let favoriteCity = sut.getFavoriteCity()

        XCTAssertNil(favoriteCity)
        XCTAssertEqual(mockPreferencesService.getFavoriteCityCallCount, 1)
    }

    func testClearFavoriteCity() {
        mockPreferencesService.savedCity = "Madrid"

        sut.clearFavoriteCity()

        XCTAssertNil(mockPreferencesService.savedCity)
        XCTAssertEqual(mockPreferencesService.clearFavoriteCityCallCount, 1)
    }

    func testResetState() {
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

        sut.resetState()

        // Then: Should return to idle
        XCTAssertEqual(sut.state, .idle)
    }
}
