//
//  HomeViewModel.swift
//  WeatherApp
//
//  ViewModel for the Home screen.
//  Handles weather fetching, input validation, and favorite city management.
//  Demonstrates MVVM, Dependency Injection, and SOLID principles.
//

import Foundation

// MARK: - HomeViewModel
/// ViewModel for home screen where users search for cities
/// Responsibilities:
/// - Fetch weather data via WeatherService
/// - Manage favorite city via UserPreferencesService
/// - Validate user input
/// - Expose state to the view via bindings/callbacks
final class HomeViewModel {

    // MARK: - State Management
    /// Represents the current state of the view
    /// Using enums for state management provides type safety and clarity
    enum State: Equatable {
        case idle
        case loading
        case loaded(WeatherData)
        case error(String)
    }

    // MARK: - Properties
    private let weatherService: WeatherServiceProtocol
    private let preferencesService: UserPreferencesServiceProtocol

    /// Current state of the view - exposed for binding
    /// Note: Setter is internal to allow test access via @testable import
    var state: State = .idle {
        didSet {
            onStateChanged?(state)
        }
    }

    /// Callback for state changes - view observes this
    var onStateChanged: ((State) -> Void)?

    // MARK: - Initialization
    /// Initializes with injected dependencies
    /// - Parameters:
    ///   - weatherService: Service for fetching weather data
    ///   - preferencesService: Service for managing user preferences
    /// This demonstrates Dependency Injection - dependencies are provided externally
    /// Benefits: Testability, flexibility, loose coupling (SOLID principles)
    init(
        weatherService: WeatherServiceProtocol,
        preferencesService: UserPreferencesServiceProtocol
    ) {
        self.weatherService = weatherService
        self.preferencesService = preferencesService
    }

    // MARK: - Public Methods
    /// Fetches weather for a given city
    /// - Parameter city: City name to search for
    func fetchWeather(for city: String) {
        // Step 1: Validate input
        let trimmedCity = city.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedCity.isEmpty else {
            state = .error(ErrorMessages.invalidCity)
            return
        }

        // Step 2: Update state to loading
        state = .loading

        // Step 3: Fetch weather asynchronously
        Task {
            do {
                let weatherData = try await weatherService.fetchWeather(for: trimmedCity)
                // Update state on main thread
                await MainActor.run {
                    state = .loaded(weatherData)
                }
            } catch let error as NetworkError {
                // Handle known network errors
                await MainActor.run {
                    state = .error(error.localizedDescription)
                }
            } catch {
                // Handle unexpected errors
                await MainActor.run {
                    state = .error(ErrorMessages.genericError)
                }
            }
        }
    }

    /// Saves city as favorite
    /// - Parameter city: City name to save
    func saveFavoriteCity(_ city: String) {
        preferencesService.saveFavoriteCity(city)
    }

    /// Retrieves saved favorite city
    /// - Returns: Favorite city name or nil
    func getFavoriteCity() -> String? {
        return preferencesService.getFavoriteCity()
    }

    /// Clears the saved favorite city
    func clearFavoriteCity() {
        preferencesService.clearFavoriteCity()
    }

    /// Resets state to idle
    func resetState() {
        state = .idle
    }
}
