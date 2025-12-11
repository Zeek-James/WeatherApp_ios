//
//  DIContainer.swift
//  WeatherApp
//
//  Dependency Injection Container for managing app dependencies.
//  Provides centralized dependency creation and injection.
//

import Foundation

// MARK: - DIContainer
/// Dependency Injection Container
/// Responsibilities:
/// - Create and configure view models
/// - Inject dependencies (services, repositories, etc.)
/// - Maintain singleton pattern for shared resources
final class DIContainer {

    // MARK: - Singleton
    static let shared = DIContainer()

    // MARK: - Services
    private let weatherService: WeatherServiceProtocol
    private let userPreferencesService: UserPreferencesService

    // MARK: - Initialization
    private init() {
        // Initialize services
        self.weatherService = WeatherService()
        self.userPreferencesService = UserPreferencesService()
    }

    // MARK: - ViewModel Factory Methods

    /// Creates a new SplashViewModel instance
    func makeSplashViewModel() -> SplashViewModel {
        return SplashViewModel()
    }

    /// Creates a new HomeViewModel instance with injected dependencies
    func makeHomeViewModel() -> HomeViewModel {
        return HomeViewModel(
            weatherService: weatherService,
            userPreferencesService: userPreferencesService
        )
    }

    /// Creates a new WeatherDetailViewModel instance with injected data
    func makeWeatherDetailViewModel(weatherData: WeatherData) -> WeatherDetailViewModel {
        return WeatherDetailViewModel(weatherData: weatherData)
    }
}
