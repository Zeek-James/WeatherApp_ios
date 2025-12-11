//
//  SplashViewController.swift
//  WeatherApp
//

import UIKit

final class SplashViewController: UIViewController {

    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startSplashTimer()
    }

    private func setupUI() {
        view.backgroundColor = .systemBlue
        appNameLabel?.font = UIFont.boldSystemFont(ofSize: 32)
        appNameLabel?.textColor = .white
        activityIndicator?.startAnimating()
        activityIndicator?.color = .white
    }

    private func startSplashTimer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + UIConstants.splashDisplayDuration) { [weak self] in
            self?.navigateToHome()
        }
    }

    private func navigateToHome() {
        guard let homeVC = storyboard?.instantiateViewController(
            withIdentifier: StoryboardID.home
        ) as? HomeViewController else {
            print("❌ Failed to instantiate HomeViewController")
            return
        }

        homeVC.viewModel = DIContainer.shared.makeHomeViewModel()

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
