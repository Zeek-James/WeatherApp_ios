//
//  DIContainer.swift
//  WeatherApp
//

import Foundation

final class DIContainer {

    static let shared = DIContainer()

    private let weatherService: WeatherServiceProtocol
    private let userPreferencesService: UserPreferencesService

    private init() {
        self.weatherService = WeatherService()
        self.userPreferencesService = UserPreferencesService()
    }

    func makeHomeViewModel() -> HomeViewModel {
        return HomeViewModel(
            weatherService: weatherService,
            preferencesService: userPreferencesService
        )
    }

    func makeWeatherDetailViewModel(weatherData: WeatherData) -> WeatherDetailViewModel {
        return WeatherDetailViewModel(weatherData: weatherData)
    }
}
