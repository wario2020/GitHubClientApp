//
//  MainCoordinator.swift
//  GitHubClientApp
//
//  Created by Chuan on 2025/5/22.
//

import Foundation
import UIKit

protocol MainCoordinatorDelegate: AnyObject {
    func didLogout()
}

class MainCoordinator: BaseCoordinator {
    let navigationController: UINavigationController
    private let authService: AuthService
    private let networkService: NetworkService
    private let imageService: ImageService
    
    weak var delegate: MainCoordinatorDelegate?
    
    init(
        navigationController: UINavigationController,
        authService: AuthService,
        networkService: NetworkService,
        imageService: ImageService
    ) {
        self.navigationController = navigationController
        self.authService = authService
        self.networkService = networkService
        self.imageService = imageService
        super.init()
    }
    
    override func start() {
        showHomeScreen()
    }
    
    private func showHomeScreen() {
        let viewModel = HomeViewModel(
            authService: authService,
            networkService: networkService,
            imageService: imageService
        )
        viewModel.delegate = self
        
        let viewController = HomeViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: false)
    }
}

extension MainCoordinator: HomeViewModelDelegate {
    func didLogout() {
        delegate?.didLogout()
    }
    
    func didLoadUser() {
        // 可以添加用户信息加载完成后的处理
    }
    
    func didFailToLoadUser(with error: Error) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: "Failed to load user information: \(error.localizedDescription)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.navigationController.present(alert, animated: true, completion: nil)
        }
    }
    
    func didLoadRepositories() {
        // 可以添加仓库加载完成后的处理
    }
    
    func didFailToLoadRepositories(with error: Error) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: "Failed to load repositories: \(error.localizedDescription)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.navigationController.present(alert, animated: true, completion: nil)
        }
    }
}    
