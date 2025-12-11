//
//  WeatherDetailViewController.swift
//  WeatherApp
//

import UIKit

final class WeatherDetailViewController: UIViewController {

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var containerView: UIView!

    var viewModel: WeatherDetailViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        displayWeatherData()
    }

    private func setupUI() {
        title = "Weather Details"
        view.backgroundColor = .systemBackground

        containerView?.backgroundColor = .secondarySystemBackground
        containerView?.layer.cornerRadius = UIConstants.cornerRadius
        containerView?.layer.shadowColor = UIColor.black.cgColor
        containerView?.layer.shadowOffset = CGSize(width: 0, height: 2)
        containerView?.layer.shadowRadius = 4
        containerView?.layer.shadowOpacity = 0.1

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
        cityLabel?.text = viewModel.cityName
        temperatureLabel?.text = viewModel.temperature
        feelsLikeLabel?.text = viewModel.feelsLike
        descriptionLabel?.text = viewModel.description
        humidityLabel?.text = viewModel.humidity
        pressureLabel?.text = viewModel.pressure
        windSpeedLabel?.text = viewModel.windSpeed
    }
}
