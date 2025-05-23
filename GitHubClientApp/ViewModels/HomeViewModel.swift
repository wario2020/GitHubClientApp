//
//  HomeViewModel.swift
//  GitHubClientApp
//
//  Created by Chuan on 2025/5/22.
//

import Foundation

protocol HomeViewModelDelegate: AnyObject {
    func didLogout()
    func didLoadUser()
    func didFailToLoadUser(with error: Error)
    func didLoadRepositories()
    func didFailToLoadRepositories(with error: Error)
}

protocol HomeViewModelProtocol {
    var delegate: HomeViewModelDelegate? { get set }
    var user: User? { get }
    var repositories: [Repository] { get }
    var isAuthenticated: Bool { get }
    
    func fetchUser()
    func fetchRepositories()
    func logout()
}

class HomeViewModel: HomeViewModelProtocol {
    weak var delegate: HomeViewModelDelegate?
    
    private(set) var user: User?
    private(set) var repositories: [Repository] = []
    private let authService: AuthServiceProtocol
    private let networkService: NetworkServiceProtocol
    private let imageService: ImageServiceProtocol
    
    var isAuthenticated: Bool {
        return authService.isAuthenticated
    }
    
    init(
        authService: AuthServiceProtocol,
        networkService: NetworkServiceProtocol,
        imageService: ImageServiceProtocol
    ) {
        self.authService = authService
        self.networkService = networkService
        self.imageService = imageService
    }
    
    func fetchUser() {
        guard isAuthenticated else {
            return
        }
        
        networkService.request(endpoint: GitHubAPI.user, responseType: User.self) { [weak self] result in
            switch result {
            case .success(let user):
                self?.user = user
                self?.delegate?.didLoadUser()
            case .failure(let error):
                self?.delegate?.didFailToLoadUser(with: error)
            }
        }
    }
    
    func fetchRepositories() {
        guard isAuthenticated else {
            return
        }
        
        networkService.request(endpoint: GitHubAPI.userRepositories, responseType: [Repository].self) { [weak self] result in
            switch result {
            case .success(let repositories):
                self?.repositories = repositories
                self?.delegate?.didLoadRepositories()
            case .failure(let error):
                self?.delegate?.didFailToLoadRepositories(with: error)
            }
        }
    }
    
    func logout() {
        authService.logout()
        delegate?.didLogout()
    }
}    
