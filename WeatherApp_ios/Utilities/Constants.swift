//
//  Constants.swift
//  WeatherApp
//
//  Centralized constants for the application.
//  This promotes maintainability and follows the DRY (Don't Repeat Yourself) principle.
//

import Foundation

// MARK: - API Constants
enum APIConstants {
    static let baseURL = "https://api.openweathermap.org/data/2.5/weather"

    // NOTE: In production, this should be stored securely (e.g., in Keychain or environment variables)
    // For the assessment, you'll need to replace this with your actual API key
    static let apiKey = "00858296717ed8c32fb586d33a7ecc4b"

    // Units: standard, metric, imperial
    static let units = "metric"

    enum HTTPHeader {
        static let contentType = "Content-Type"
        static let applicationJSON = "application/json"
    }
}

// MARK: - UserDefaults Keys
enum UserDefaultsKeys {
    static let favoriteCityKey = "favoriteCityKey"
}

// MARK: - Storyboard Identifiers
enum StoryboardID {
    static let splash = "SplashViewController"
    static let home = "HomeViewController"
    static let weatherDetail = "WeatherDetailViewController"
}

// MARK: - UI Constants
enum UIConstants {
    static let splashDisplayDuration: TimeInterval = 2.0
    static let cornerRadius: CGFloat = 12.0
    static let standardPadding: CGFloat = 16.0
}

// MARK: - Error Messages
enum ErrorMessages {
    static let invalidCity = "Please enter a valid city name"
    static let noInternetConnection = "No internet connection. Please check your network."
    static let genericError = "Something went wrong. Please try again."
    static let cityNotFound = "City not found. Please check the spelling."
}
