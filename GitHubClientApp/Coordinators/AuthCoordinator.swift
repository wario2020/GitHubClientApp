//
//  AuthCoordinator.swift
//  GitHubClientApp
//
//  Created by Chuan on 2025/5/22.
//

import Foundation
import UIKit


protocol AuthCoordinatorDelegate: AnyObject {
    func authenticationDidSucceed()
}

class AuthCoordinator: BaseCoordinator {
    let navigationController: UINavigationController
    private let authService: AuthService
    private let keychainService: KeychainService
    private let networkService: NetworkService
    
    weak var delegate: AuthCoordinatorDelegate?
    
    init(
        navigationController: UINavigationController,
        authService: AuthService,
        keychainService: KeychainService,
        networkService: NetworkService
    ) {
        self.navigationController = navigationController
        self.authService = authService
        self.keychainService = keychainService
        self.networkService = networkService
        super.init()
    }
    
    override func start() {
        showLoginScreen()
    }
    
    private func showLoginScreen() {
        let viewModel = LoginViewModel(
            authService: authService,
            keychainService: keychainService,
            networkService: networkService
        )
        viewModel.delegate = self
        
        let viewController = LoginViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: false)
    }
}

extension AuthCoordinator: LoginViewModelDelegate {
    func loginSucceeded() {
        delegate?.authenticationDidSucceed()
    }
    
    func loginFailed(with error: Error) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Login Failed", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.navigationController.present(alert, animated: true, completion: nil)
        }
    }
}    

