//
//  AppCoordinator.swift
//  GitHubClientApp
//
//  Created by Chuan on 2025/5/22.
//

import Foundation
import UIKit

class AppCoordinator: BaseCoordinator, AuthCoordinatorDelegate, MainCoordinatorDelegate {
    private let window: UIWindow
    private let authService: AuthService
    private let keychainService: KeychainService
    private let networkService: NetworkService
    private let imageService: ImageService
    
    init(
        window: UIWindow,
        authService: AuthService,
        keychainService: KeychainService,
        networkService: NetworkService,
        imageService: ImageService
    ) {
        self.window = window
        self.authService = authService
        self.keychainService = keychainService
        self.networkService = networkService
        self.imageService = imageService
        super.init()
    }
    
    override func start() {
//        if authService.isAuthenticated {
            showMainFlow()
//        } else {
//            showAuthFlow()
//        }
    }
    
    private func showAuthFlow() {
        let authCoordinator = AuthCoordinator(
            navigationController: UINavigationController(),
            authService: authService,
            keychainService: keychainService,
            networkService: networkService
        )
        authCoordinator.delegate = self
        childCoordinators.append(authCoordinator)
        (authCoordinator as Coordinator).start()
        window.rootViewController = authCoordinator.navigationController
    }
    
    private func showMainFlow() {
        let mainCoordinator = MainCoordinator(
            navigationController: UINavigationController(),
            authService: authService,
            networkService: networkService,
            imageService: imageService
        )
        mainCoordinator.delegate = self
        childCoordinators.append(mainCoordinator)
        (mainCoordinator as Coordinator).start()
        window.rootViewController = mainCoordinator.navigationController
    }
    
    // 实现AuthCoordinatorDelegate协议方法
    func authenticationDidSucceed() {
        // 移除之前的协调器
        childCoordinators.removeAll()
        showMainFlow()
    }
    
    // 实现MainCoordinatorDelegate协议方法
    func didLogout() {
        // 移除之前的协调器
        childCoordinators.removeAll()
        showAuthFlow()
    }
}    
