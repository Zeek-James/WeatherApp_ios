# iOS Weather App

A native iOS weather application built with Swift, demonstrating professional iOS development practices including MVVM architecture, dependency injection, protocol-oriented programming, and comprehensive unit testing.

<div align="center">

![Swift](https://img.shields.io/badge/Swift-5.0+-orange.svg)
![iOS](https://img.shields.io/badge/iOS-13.0+-blue.svg)
![Platform](https://img.shields.io/badge/platform-iOS-lightgrey.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)

</div>

## 📱 Screenshots

| Home Screen | Weather Details | Loading State |
|-------------|----------------|---------------|
| Search for cities | View detailed weather | Real-time updates |

## ✨ Features

- 🔍 **City Search**: Search current weather by city name
- 🌡️ **Detailed Weather**: Temperature, feels like, humidity, pressure, wind speed
- ⭐ **Favorite City**: Save and auto-load your preferred city
- 🎨 **Clean UI**: Modern, user-friendly interface
- ⚡ **Real-time Data**: Live weather data from OpenWeather API
- 🛡️ **Error Handling**: Comprehensive error messages for all scenarios
- 📱 **Multiple Screens**: Splash screen, search screen, and detail screen

## 🏗️ Architecture

This project follows **MVVM (Model-View-ViewModel)** architecture pattern with **Dependency Injection** for clean, testable, and maintainable code.

```
┌─────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                    │
│  ┌──────────────┐         ┌──────────────┐              │
│  │ View         │◄────────┤ ViewModel    │              │
│  │ Controller   │ observe │              │              │
│  └──────────────┘  state  └──────┬───────┘              │
└───────────────────────────────────┼───────────────────────┘
                                    │
┌───────────────────────────────────┼───────────────────────┐
│                    BUSINESS LOGIC LAYER                   │
│                           ┌───────▼────────┐              │
│                           │    Service     │              │
│                           │   Protocol     │              │
│                           └───────┬────────┘              │
└───────────────────────────────────┼───────────────────────┘
                                    │
┌───────────────────────────────────┼───────────────────────┐
│                    DATA LAYER                             │
│                           ┌───────▼────────┐              │
│                           │   URLSession   │              │
│                           │   API Client   │              │
│                           └────────────────┘              │
└───────────────────────────────────────────────────────────┘
```

### Key Components

- **Views**: UIViewControllers handling UI updates and user interactions
- **ViewModels**: Business logic, state management, and data transformation
- **Services**: API communication and data persistence
- **Models**: Domain models (WeatherData) and API models (WeatherResponse)
- **Utilities**: Dependency injection container, constants, and error handling

## 🎯 SOLID Principles

This project demonstrates all five SOLID principles:

| Principle | Implementation |
|-----------|----------------|
| **Single Responsibility** | Each class has one clear responsibility (e.g., WeatherService only fetches weather) |
| **Open/Closed** | Protocol-based design allows extension without modification |
| **Liskov Substitution** | Mock implementations can replace real ones seamlessly |
| **Interface Segregation** | Small, focused protocols (WeatherServiceProtocol) |
| **Dependency Inversion** | High-level modules depend on abstractions (protocols), not concretions |

## 💉 Dependency Injection

The app uses **Constructor Injection** with a **DI Container** for managing dependencies:

```swift
// HomeViewModel.swift
init(weatherService: WeatherServiceProtocol,
     preferencesService: UserPreferencesServiceProtocol) {
    self.weatherService = weatherService
    self.preferencesService = preferencesService
}

// DIContainer.swift
func makeHomeViewModel() -> HomeViewModel {
    return HomeViewModel(
        weatherService: weatherService,
        userPreferencesService: userPreferencesService
    )
}
```

**Benefits**:
- ✅ Easy to test with mock dependencies
- ✅ Loose coupling between components
- ✅ Flexible and maintainable code
- ✅ Follows Dependency Inversion Principle

## 🧪 Unit Testing

The project includes **16 comprehensive unit tests** with **60%+ code coverage**.

### Test Coverage

| Component | Tests | Coverage |
|-----------|-------|----------|
| **HomeViewModel** | 11 tests | ✅ High |
| **WeatherService** | 5 tests | ✅ High |
| **Networking** | Mocked | ✅ Complete |

### Testing Strategy

- **AAA Pattern**: Arrange-Act-Assert for clear test structure
- **Test Doubles**: Mocks for network and persistence layers
- **Async Testing**: XCTest expectations for async/await code
- **Protocol Abstraction**: URLSessionProtocol enables network mocking

```swift
// Example Test
func testFetchWeather_Success() async {
    // Arrange
    mockWeatherService.mockWeatherData = testData

    // Act
    sut.fetchWeather(for: "London")

    // Assert
    XCTAssertEqual(sut.state, .loaded(testData))
}
```

## 🔄 View Lifecycle

The app demonstrates proper UIViewController lifecycle management across three screens:

### 1. Splash Screen
- `viewDidLoad()`: Setup UI and ViewModel
- `viewDidAppear()`: Start splash timer
- Automatic navigation after 2 seconds

### 2. Home Screen
- `viewDidLoad()`: Configure UI, setup ViewModel bindings, load favorite city
- State observation for loading/error/success handling
- Proper keyboard dismissal and user feedback

### 3. Weather Detail Screen
- `viewDidLoad()`: Setup UI, display weather data
- Custom transitions with animation
- Clean data presentation with formatted values

## 🛠️ Technologies & Patterns

### Technologies
- **Language**: Swift 5.0+
- **UI Framework**: UIKit with Storyboards
- **Networking**: URLSession with async/await
- **Concurrency**: Swift Concurrency (async/await, MainActor)
- **Persistence**: UserDefaults
- **Testing**: XCTest

### Design Patterns
- ✅ MVVM (Architecture)
- ✅ Dependency Injection
- ✅ Protocol-Oriented Programming
- ✅ State Pattern (enum-based states)
- ✅ Adapter Pattern (API to domain model mapping)
- ✅ Factory Pattern (DIContainer)
- ✅ Observer Pattern (state change callbacks)
- ✅ Repository Pattern (data access abstraction)

## 📁 Project Structure

```
WeatherApp_ios/
├── App/
│   ├── AppDelegate.swift              # App lifecycle
│   └── SceneDelegate.swift            # Scene configuration & DI
├── Models/
│   ├── WeatherData.swift              # Domain model
│   └── WeatherResponse.swift          # API response model
├── ViewModels/
│   ├── HomeViewModel.swift            # Search screen logic
│   ├── SplashViewModel.swift          # Splash screen logic
│   └── WeatherDetailViewModel.swift   # Detail screen logic
├── Views/
│   ├── Controllers/
│   │   ├── HomeViewController.swift
│   │   ├── SplashViewController.swift
│   │   └── WeatherDetailViewController.swift
│   └── Main.storyboard                # UI layouts
├── Services/
│   ├── WeatherService.swift           # API implementation
│   ├── WeatherServiceProtocol.swift   # Service abstraction
│   └── UserPreferencesService.swift   # Persistence layer
├── Utilities/
│   ├── Constants.swift                # App constants
│   ├── NetworkError.swift             # Custom error types
│   └── DIContainer.swift              # Dependency injection
└── Tests/
    ├── HomeViewModelTests.swift       # ViewModel tests
    ├── WeatherServiceTests.swift      # Service tests
    └── Mocks/
        └── MockURLSession.swift       # Test doubles
```

## 🚀 Getting Started

### Prerequisites

- Xcode 13.0+
- iOS 13.0+
- Swift 5.0+
- OpenWeather API Key (free tier available)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/Zeek-James/WeatherApp_ios.git
   cd WeatherApp_ios
   ```

2. **Open in Xcode**
   ```bash
   open WeatherApp_ios.xcodeproj
   ```

3. **Add API Key**
   - Open `Utilities/Constants.swift`
   - Replace the API key with your own from [OpenWeather API](https://openweathermap.org/api)
   ```swift
   static let apiKey = "YOUR_API_KEY_HERE"
   ```

4. **Build and Run**
   - Select a simulator or device
   - Press `Cmd + R` or click the Run button
   - App will launch on your selected device

### Running Tests

```bash
# In Xcode: Press Cmd + U
# Or from command line:
xcodebuild test -project WeatherApp_ios.xcodeproj -scheme WeatherApp_ios -destination 'platform=iOS Simulator,name=iPhone 15'
```

## 📖 Usage

1. **Search for Weather**
   - Launch the app (2-second splash screen)
   - Enter a city name (e.g., "London", "Paris", "Tokyo")
   - Tap "Search Weather"
   - View detailed weather information

2. **Save Favorite City**
   - Enter a city name
   - Tap "Save as Favorite"
   - City will auto-load on next launch

3. **View Weather Details**
   - After successful search
   - See temperature, feels like, humidity, pressure, wind speed
   - Navigate back to search for another city

## 🔍 Code Highlights

### Modern Swift Concurrency
```swift
Task {
    do {
        let data = try await weatherService.fetchWeather(for: city)
        await MainActor.run {
            state = .loaded(data)
        }
    } catch let error as NetworkError {
        await MainActor.run {
            state = .error(error.localizedDescription)
        }
    }
}
```

### State Management
```swift
enum State: Equatable {
    case idle
    case loading
    case loaded(WeatherData)
    case error(String)
}
```

### Protocol-Oriented Testing
```swift
protocol WeatherServiceProtocol {
    func fetchWeather(for city: String) async throws -> WeatherData
}

// Production
class WeatherService: WeatherServiceProtocol { }

// Testing
class MockWeatherService: WeatherServiceProtocol { }
```

## 🎯 Key Features Demonstrated

### 1. SOLID Principles ✅
- Single Responsibility: Each class has one clear purpose
- Open/Closed: Extensible through protocols
- Liskov Substitution: Mocks replace real implementations
- Interface Segregation: Focused, minimal protocols
- Dependency Inversion: Depends on abstractions

### 2. Dependency Injection ✅
- Constructor injection pattern
- DIContainer for centralized dependency management
- Protocol-based abstractions
- Testable architecture

### 3. Unit Testing ✅
- Comprehensive unit tests
- Mock objects for isolation
- Async/await testing
- 60%+ code coverage

### 4. Multiple Screens & Lifecycle ✅
- Splash Screen with timer
- Home Screen with search functionality
- Detail Screen with formatted data
- Proper lifecycle management (viewDidLoad, viewDidAppear)
- State-driven UI updates

## 🚧 Future Enhancements

- [ ] Location-based weather detection
- [ ] Multiple saved cities
- [ ] Unit conversion (Celsius/Fahrenheit)
- [ ] Dark mode support
- [ ] Offline caching with CoreData

## 📝 Requirements Checklist

This project fulfills all technical requirements:

- ✅ **SOLID Principles**: All 5 principles demonstrated
- ✅ **Dependency Injection**: DIContainer with constructor injection
- ✅ **Unit Tests**: tests with mocks and protocol abstraction
- ✅ **Multiple Screens**: 3 screens with proper view lifecycle
- ✅ **GitHub Repository**: Professional README and documentation

## 🙏 Acknowledgments

- Weather data provided by [OpenWeather API](https://openweathermap.org/)

---

