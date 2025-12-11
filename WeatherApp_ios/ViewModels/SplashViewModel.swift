//
//  SplashViewModel.swift
//  WeatherApp
//
//  ViewModel for the Splash screen.
//  Handles splash screen timing and navigation logic.
//  Part of MVVM architecture - separates presentation logic from view.
//

import Foundation

// MARK: - SplashViewModel
/// ViewModel for splash screen
/// Responsibilities:
/// - Manage splash screen display duration
/// - Signal when to navigate to home screen
/// - Could be extended for initial data loading, authentication checks, etc.
final class SplashViewModel {

    // MARK: - Properties
    /// Callback closure to notify when splash should complete
    /// Using closure-based callback for simplicity
    /// Alternative: Could use Combine or delegation pattern
    var onSplashComplete: (() -> Void)?

    // MARK: - Public Methods
    /// Starts the splash screen timer
    /// After the defined duration, triggers navigation to home
    func startSplashTimer() {
        // Simulate splash screen display duration
        // In a real app, this might wait for:
        // - Network connectivity check
        // - Initial data loading
        // - Authentication validation
        DispatchQueue.main.asyncAfter(deadline: .now() + UIConstants.splashDisplayDuration) { [weak self] in
            self?.onSplashComplete?()
        }
    }
}
