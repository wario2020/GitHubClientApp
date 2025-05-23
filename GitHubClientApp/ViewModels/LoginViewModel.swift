//
//  LoginViewModel.swift
//  GitHubClientApp
//
//  Created by Chuan on 2025/5/22.
//

import Foundation

protocol LoginViewModelDelegate: AnyObject {
    func loginSucceeded()
    func loginFailed(with error: Error)
}

protocol LoginViewModelProtocol {
    var delegate: LoginViewModelDelegate? { get set }
    
    func login(username: String, password: String)
    func authenticateWithBiometrics()
    func saveCredentials(username: String, password: String)
}

class LoginViewModel: LoginViewModelProtocol {
    weak var delegate: LoginViewModelDelegate?
    
    private let authService: AuthServiceProtocol
    private var keychainService: KeychainServiceProtocol
    
    init(
        authService: AuthServiceProtocol,
        keychainService: KeychainServiceProtocol,
        networkService: NetworkServiceProtocol
    ) {
        self.authService = authService
        self.keychainService = keychainService
    }
    
    func login(username: String, password: String) {
        authService.login(username: username, password: password) { [weak self] result in
            switch result {
            case .success:
                self?.saveCredentials(username: username, password: password)
                self?.delegate?.loginSucceeded()
            case .failure(let error):
                self?.delegate?.loginFailed(with: error)
            }
        }
    }
    
    func authenticateWithBiometrics() {
        authService.authenticateWithBiometrics { [weak self] result in
            switch result {
            case .success:
                self?.delegate?.loginSucceeded()
            case .failure(let error):
                self?.delegate?.loginFailed(with: error)
            }
        }
    }
    
    func saveCredentials(username: String, password: String) {
        keychainService.username = username
        keychainService.password = password
    }
}    
