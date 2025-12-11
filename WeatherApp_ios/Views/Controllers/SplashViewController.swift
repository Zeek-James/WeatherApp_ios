//
//  SplashViewController.swift
//  WeatherApp
//
//  Splash screen displayed on app launch.
//  Demonstrates UIViewController lifecycle and navigation.
//  Part of MVVM pattern - view observes ViewModel.
//

import UIKit

// MARK: - SplashViewController
/// Initial splash screen shown on app launch
/// Responsibilities:
/// - Display branding/logo
/// - Navigate to home screen after delay
/// - Could be extended for initialization tasks
final class SplashViewController: UIViewController {

    // MARK: - UI Components
    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    // MARK: - Properties
    /// ViewModel injected via DI Container
    var viewModel: SplashViewModel!

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewModel()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Start splash timer when view appears
        viewModel.startSplashTimer()
    }

    // MARK: - Setup Methods
    private func setupUI() {
        // Configure UI elements
        view.backgroundColor = .systemBlue
        appNameLabel?.font = UIFont.boldSystemFont(ofSize: 32)
        appNameLabel?.textColor = .white
        activityIndicator?.startAnimating()
        activityIndicator?.color = .white
    }

    private func setupViewModel() {
        // Observe ViewModel state changes
        viewModel.onSplashComplete = { [weak self] in
            self?.navigateToHome()
        }
    }

    // MARK: - Navigation
    private func navigateToHome() {
        // Navigate to home screen
        // Using storyboard segue or programmatic navigation
        guard let homeVC = storyboard?.instantiateViewController(
            withIdentifier: StoryboardID.home
        ) as? HomeViewController else {
            print("❌ Failed to instantiate HomeViewController")
            return
        }

        // Inject dependencies via DI Container
        homeVC.viewModel = DIContainer.shared.makeHomeViewModel()

        // Set as root view controller with animation
        if let window = view.window {
            UIView.transition(
                with: window,
                duration: 0.3,
                options: .transitionCrossDissolve,
                animations: {
                    window.rootViewController = UINavigationController(rootViewController: homeVC)
                }
            )
        }
    }
}
