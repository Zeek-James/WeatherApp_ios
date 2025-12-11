//
//  WeatherDetailViewController.swift
//  WeatherApp
//
//  Detail screen showing complete weather information.
//  Demonstrates MVVM data presentation and view lifecycle.
//

import UIKit

// MARK: - WeatherDetailViewController
/// Screen displaying detailed weather information
/// Responsibilities:
/// - Display weather data in a user-friendly format
/// - Could be extended with refresh, share, forecast, etc.
final class WeatherDetailViewController: UIViewController {

    // MARK: - UI Components
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var containerView: UIView!

    // MARK: - Properties
    /// ViewModel injected via DI Container
    var viewModel: WeatherDetailViewModel!

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        displayWeatherData()
    }

    // MARK: - Setup Methods
    private func setupUI() {
        title = "Weather Details"
        view.backgroundColor = .systemBackground

        // Configure container view
        containerView?.backgroundColor = .secondarySystemBackground
        containerView?.layer.cornerRadius = UIConstants.cornerRadius
        containerView?.layer.shadowColor = UIColor.black.cgColor
        containerView?.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView?.layer.shadowRadius = 4
        containerView?.layer.shadowOpacity = 0.1

        // Configure labels
        cityLabel?.font = UIFont.boldSystemFont(ofSize: 28)
        cityLabel?.textAlignment = .center
        cityLabel?.textColor = .label

        temperatureLabel?.font = UIFont.systemFont(ofSize: 48, weight: .bold)
        temperatureLabel?.textAlignment = .center
        temperatureLabel?.textColor = .systemBlue

        feelsLikeLabel?.font = UIFont.systemFont(ofSize: 16)
        feelsLikeLabel?.textAlignment = .center
        feelsLikeLabel?.textColor = .secondaryLabel

        descriptionLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        descriptionLabel?.textAlignment = .center
        descriptionLabel?.textColor = .label

        humidityLabel?.font = UIFont.systemFont(ofSize: 16)
        humidityLabel?.textColor = .secondaryLabel

        pressureLabel?.font = UIFont.systemFont(ofSize: 16)
        pressureLabel?.textColor = .secondaryLabel

        windSpeedLabel?.font = UIFont.systemFont(ofSize: 16)
        windSpeedLabel?.textColor = .secondaryLabel
    }

    private func displayWeatherData() {
        // Populate UI with ViewModel data
        cityLabel?.text = viewModel.cityName
        temperatureLabel?.text = viewModel.temperature
        feelsLikeLabel?.text = viewModel.feelsLike
        descriptionLabel?.text = viewModel.description
        humidityLabel?.text = viewModel.humidity
        pressureLabel?.text = viewModel.pressure
        windSpeedLabel?.text = viewModel.windSpeed
    }
}
