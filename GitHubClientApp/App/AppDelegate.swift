//
//  AppDelegate.swift
//  GitHubClientApp
//
//  Created by Chuan on 2025/5/22.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    // 将各个Service作为属性存储，避免每次都新建
    let authService = AuthService()
    let keychainService = KeychainService()
    let networkService = NetworkService()
    let imageService = ImageService()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        setupRootViewController()
        window?.makeKeyAndVisible()

        return true
    }

    private func setupRootViewController() {
        let coordinator = AppCoordinator(
            window: window!,
            authService: authService,
            keychainService: keychainService,
            networkService: networkService,
            imageService: imageService
        )
        coordinator.start()
    }
}
