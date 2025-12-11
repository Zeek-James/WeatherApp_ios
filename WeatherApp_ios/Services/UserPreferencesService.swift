//
//  UserPreferencesService.swift
//  WeatherApp
//
//  Service for managing user preferences using UserDefaults.
//  Follows Single Responsibility Principle - dedicated to user preferences management.
//  Uses protocol for testability (Dependency Inversion Principle).
//

import Foundation

// MARK: - UserPreferencesServiceProtocol
/// Protocol defining user preferences management contract
/// Allows for easy mocking in tests and alternative implementations
protocol UserPreferencesServiceProtocol {
    /// Saves favorite city to persistent storage
    /// - Parameter city: City name to save
    func saveFavoriteCity(_ city: String)

    /// Retrieves saved favorite city
    /// - Returns: Saved city name or nil if none exists
    func getFavoriteCity() -> String?

    /// Clears saved favorite city
    func clearFavoriteCity()
}

// MARK: - UserPreferencesService
/// Concrete implementation using UserDefaults for persistence
/// UserDefaults is appropriate for simple key-value storage
/// For more complex data, consider CoreData or Realm
final class UserPreferencesService: UserPreferencesServiceProtocol {

    // MARK: - Properties
    private let userDefaults: UserDefaults

    // MARK: - Initialization
    /// Initializes service with dependency injection
    /// - Parameter userDefaults: UserDefaults instance (injectable for testing)
    init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    // MARK: - UserPreferencesServiceProtocol Implementation
    func saveFavoriteCity(_ city: String) {
        userDefaults.set(city, forKey: UserDefaultsKeys.favoriteCityKey)
        userDefaults.synchronize() // Force immediate save
        print("✅ Saved favorite city: \(city)")
    }

    func getFavoriteCity() -> String? {
        let city = userDefaults.string(forKey: UserDefaultsKeys.favoriteCityKey)
        print("📖 Retrieved favorite city: \(city ?? "none")")
        return city
    }

    func clearFavoriteCity() {
        userDefaults.removeObject(forKey: UserDefaultsKeys.favoriteCityKey)
        userDefaults.synchronize()
        print("🗑️ Cleared favorite city")
    }
}
