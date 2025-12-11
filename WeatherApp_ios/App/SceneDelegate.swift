//
//  SceneDelegate.swift
//  WeatherApp
//
//  Scene delegate managing window scenes and scene lifecycle.
//  Handles scene-based lifecycle events (iOS 13+).
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        // Use this method to optionally configure and attach the UIWindow `window` to the
        // provided UIWindowScene `scene`.
        guard let windowScene = (scene as? UIWindowScene) else { return }

        // Create window
        let window = UIWindow(windowScene: windowScene)

        // Load storyboard
        let storyboard = UIStoryboard(name: "Main", bundle: nil)

        // Instantiate initial view controller (Splash)
        if let splashVC = storyboard.instantiateViewController(
            withIdentifier: StoryboardID.splash
        ) as? SplashViewController {
            // Inject dependencies
            splashVC.viewModel = DIContainer.shared.makeSplashViewModel()

            // Set as root
            window.rootViewController = splashVC
        }

        self.window = window
        window.makeKeyAndVisible()

        print("✅ Scene connected and window configured")
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
    }
}
