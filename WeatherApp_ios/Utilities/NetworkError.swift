//
//  NetworkError.swift
//  WeatherApp
//

import Foundation

// MARK: - NetworkError
enum NetworkError: Error, LocalizedError, Equatable {
    case invalidURL
    case noData
    case decodingError
    case serverError(statusCode: Int)
    case networkUnavailable
    case cityNotFound
    case unauthorized
    case unknown(Error)

    // MARK: - LocalizedError Conformance
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid request. Please try again."
        case .noData:
            return "No data received from server."
        case .decodingError:
            return "Unable to process server response."
        case .serverError(let statusCode):
            return "Server error (Code: \(statusCode)). Please try again later."
        case .networkUnavailable:
            return ErrorMessages.noInternetConnection
        case .cityNotFound:
            return ErrorMessages.cityNotFound
        case .unauthorized:
            return "API key is invalid. Please check your configuration."
        case .unknown(let error):
            return error.localizedDescription
        }
    }

    // MARK: - Equatable Conformance
    static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.invalidURL, .invalidURL),
             (.noData, .noData),
             (.decodingError, .decodingError),
             (.networkUnavailable, .networkUnavailable),
             (.cityNotFound, .cityNotFound),
             (.unauthorized, .unauthorized):
            return true
        case (.serverError(let lhsCode), .serverError(let rhsCode)):
            return lhsCode == rhsCode
        case (.unknown, .unknown):
            // For testing purposes, consider unknown errors equal
            return true
        default:
            return false
        }
    }
}
