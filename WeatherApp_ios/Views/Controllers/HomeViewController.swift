//
//  HomeViewController.swift
//  WeatherApp
//
//  Home screen where users search for cities.
//  Demonstrates MVVM data binding, user interaction handling, and navigation.
//  Shows proper UIViewController lifecycle management.
//

import UIKit

// MARK: - HomeViewController
/// Main screen for city search and weather lookup
/// Responsibilities:
/// - Collect user input (city name)
/// - Display loading states
/// - Show error messages
/// - Navigate to weather detail screen
/// - Manage favorite city
final class HomeViewController: UIViewController {

    // MARK: - UI Components
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!

    // MARK: - Properties
    /// ViewModel injected via DI Container
    var viewModel: HomeViewModel!

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewModel()
        loadFavoriteCity()
    }

    // MARK: - Setup Methods
    private func setupUI() {
        title = "Weather Search"
        navigationController?.navigationBar.prefersLargeTitles = true

        // Configure text field
        cityTextField.placeholder = "Enter city name"
        cityTextField.borderStyle = .roundedRect
        cityTextField.autocapitalizationType = .words
        cityTextField.autocorrectionType = .no
        cityTextField.returnKeyType = .search
        cityTextField.delegate = self

        // Configure search button
        searchButton.setTitle("Search Weather", for: .normal)
        searchButton.backgroundColor = .systemBlue
        searchButton.setTitleColor(.white, for: .normal)
        searchButton.layer.cornerRadius = UIConstants.cornerRadius

        // Configure favorite button
        favoriteButton.setTitle("Save as Favorite", for: .normal)
        favoriteButton.setTitleColor(.systemOrange, for: .normal)

        // Configure error label
        errorLabel.textColor = .systemRed
        errorLabel.numberOfLines = 0
        errorLabel.textAlignment = .center
        errorLabel.isHidden = true

        // Configure activity indicator
        activityIndicator.hidesWhenStopped = true
    }

    private func setupViewModel() {
        // Bind ViewModel state changes to UI updates
        viewModel.onStateChanged = { [weak self] state in
            self?.handleStateChange(state)
        }
    }

    private func loadFavoriteCity() {
        // Pre-populate text field with favorite city if exists
        if let favoriteCity = viewModel.getFavoriteCity() {
            cityTextField.text = favoriteCity
        }
    }

    // MARK: - State Handling
    private func handleStateChange(_ state: HomeViewModel.State) {
        switch state {
        case .idle:
            activityIndicator.stopAnimating()
            errorLabel.isHidden = true
            searchButton.isEnabled = true

        case .loading:
            activityIndicator.startAnimating()
            errorLabel.isHidden = true
            searchButton.isEnabled = false
            view.endEditing(true) // Dismiss keyboard

        case .loaded(let weatherData):
            activityIndicator.stopAnimating()
            errorLabel.isHidden = true
            searchButton.isEnabled = true
            navigateToWeatherDetail(with: weatherData)

        case .error(let message):
            activityIndicator.stopAnimating()
            errorLabel.text = message
            errorLabel.isHidden = false
            searchButton.isEnabled = true
        }
    }

    // MARK: - Actions
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        performSearch()
    }

    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        guard let city = cityTextField.text,
              !city.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            showAlert(message: "Please enter a city name first")
            return
        }
        viewModel.saveFavoriteCity(city)
        showAlert(message: "City saved as favorite!")
    }

    // MARK: - Private Methods
    private func performSearch() {
        guard let city = cityTextField.text else { return }
        viewModel.fetchWeather(for: city)
    }

    private func navigateToWeatherDetail(with weatherData: WeatherData) {
        guard let detailVC = storyboard?.instantiateViewController(
            withIdentifier: StoryboardID.weatherDetail
        ) as? WeatherDetailViewController else {
            print("❌ Failed to instantiate WeatherDetailViewController")
            return
        }

        // Create and inject ViewModel
        detailVC.viewModel = DIContainer.shared.makeWeatherDetailViewModel(weatherData: weatherData)

        // Navigate
        navigationController?.pushViewController(detailVC, animated: true)

        // Reset state for next search
        viewModel.resetState()
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(
            title: nil,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITextFieldDelegate
extension HomeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        performSearch()
        return true
    }
}
