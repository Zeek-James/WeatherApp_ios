//
//  UserPreferencesService.swift
//  WeatherApp
//

import Foundation

// MARK: - UserPreferencesServiceProtocol

protocol UserPreferencesServiceProtocol {

    func saveFavoriteCity(_ city: String)


    func getFavoriteCity() -> String?

 
    func clearFavoriteCity()
}

// MARK: - UserPreferencesService

final class UserPreferencesService: UserPreferencesServiceProtocol {

    // MARK: - Properties
    private let userDefaults: UserDefaults

    // MARK: - Initialization
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    // MARK: - UserPreferencesServiceProtocol Implementation
    func saveFavoriteCity(_ city: String) {
        userDefaults.set(city, forKey: UserDefaultsKeys.favoriteCityKey)
        userDefaults.synchronize() // Force immediate save
        print("Saved favorite city: \(city)")
    }

    func getFavoriteCity() -> String? {
        let city = userDefaults.string(forKey: UserDefaultsKeys.favoriteCityKey)
        print("Retrieved favorite city: \(city ?? "none")")
        return city
    }

    func clearFavoriteCity() {
        userDefaults.removeObject(forKey: UserDefaultsKeys.favoriteCityKey)
        userDefaults.synchronize()
        print("Cleared favorite city")
    }
}
