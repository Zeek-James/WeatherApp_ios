//
//  HomeViewController.swift
//  WeatherApp
//

import UIKit

final class HomeViewController: UIViewController {

    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!

    var viewModel: HomeViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupViewModel()
        loadFavoriteCity()
    }

    private func setupUI() {
        title = "Weather Search"
        navigationController?.navigationBar.prefersLargeTitles = true

        cityTextField.placeholder = "Enter city name"
        cityTextField.borderStyle = .roundedRect
        cityTextField.autocapitalizationType = .words
        cityTextField.autocorrectionType = .no
        cityTextField.returnKeyType = .search
        cityTextField.delegate = self
        cityTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)

        searchButton.setTitle("Search Weather", for: .normal)
        searchButton.backgroundColor = .systemBlue
        searchButton.setTitleColor(.white, for: .normal)
        searchButton.layer.cornerRadius = UIConstants.cornerRadius

        favoriteButton.setTitle("Save as Favorite", for: .normal)
        favoriteButton.setTitleColor(.systemOrange, for: .normal)
        favoriteButton.isEnabled = false

        errorLabel.textColor = .systemRed
        errorLabel.numberOfLines = 0
        errorLabel.textAlignment = .center
        errorLabel.isHidden = true

        activityIndicator.hidesWhenStopped = true
    }

    private func setupViewModel() {
        viewModel.onStateChanged = { [weak self] state in
            self?.handleStateChange(state)
        }
    }

    private func loadFavoriteCity() {
        if let favoriteCity = viewModel.getFavoriteCity() {
            cityTextField.text = favoriteCity
        }
    }
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
            view.endEditing(true)

        case .loaded(let weatherData):
            activityIndicator.stopAnimating()
            errorLabel.isHidden = true
            searchButton.isEnabled = true
            favoriteButton.isEnabled = true
            navigateToWeatherDetail(with: weatherData)

        case .error(let message):
            activityIndicator.stopAnimating()
            errorLabel.text = message
            errorLabel.isHidden = false
            searchButton.isEnabled = true
        }
    }
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        performSearch()
    }

    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        if viewModel.saveFavoriteCity() {
            showAlert(message: "City saved as favorite!")
        } else {
            showAlert(message: "Please search for a valid city first")
        }
    }
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

        detailVC.viewModel = DIContainer.shared.makeWeatherDetailViewModel(weatherData: weatherData)
        navigationController?.pushViewController(detailVC, animated: true)
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

    @objc private func textFieldDidChange() {
        favoriteButton.isEnabled = false
    }
}

extension HomeViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        performSearch()
        return true
    }
}
