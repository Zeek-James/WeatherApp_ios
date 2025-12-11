//
//  HomeViewModel.swift
//  WeatherApp
//

import Foundation

final class HomeViewModel {

    enum State: Equatable {
        case idle
        case loading
        case loaded(WeatherData)
        case error(String)
    }

    private let weatherService: WeatherServiceProtocol
    private let preferencesService: UserPreferencesServiceProtocol
    private var lastValidatedCity: String?

    var state: State = .idle {
        didSet {
            onStateChanged?(state)
        }
    }

    var onStateChanged: ((State) -> Void)?
    init(
        weatherService: WeatherServiceProtocol,
        preferencesService: UserPreferencesServiceProtocol
    ) {
        self.weatherService = weatherService
        self.preferencesService = preferencesService
    }

    func fetchWeather(for city: String) {
        let trimmedCity = city.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedCity.isEmpty else {
            state = .error(ErrorMessages.invalidCity)
            return
        }

        state = .loading

        Task {
            do {
                let weatherData = try await weatherService.fetchWeather(for: trimmedCity)
                await MainActor.run {
                    self.lastValidatedCity = trimmedCity
                    state = .loaded(weatherData)
                }
            } catch let error as NetworkError {
                await MainActor.run {
                    state = .error(error.localizedDescription)
                }
            } catch {
                await MainActor.run {
                    state = .error(ErrorMessages.genericError)
                }
            }
        }
    }

    func canSaveFavorite() -> Bool {
        return lastValidatedCity != nil
    }

    func saveFavoriteCity() -> Bool {
        guard let validCity = lastValidatedCity else {
            return false
        }
        preferencesService.saveFavoriteCity(validCity)
        return true
    }

    func getFavoriteCity() -> String? {
        return preferencesService.getFavoriteCity()
    }

    func clearFavoriteCity() {
        preferencesService.clearFavoriteCity()
    }

    func resetState() {
        state = .idle
    }
}
