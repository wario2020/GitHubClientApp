//
//  AuthService.swift
//  GitHubClientApp
//
//  Created by Chuan on 2025/5/22.
//

import Foundation
import LocalAuthentication

protocol AuthServiceProtocol {
    var isAuthenticated: Bool { get }
    var currentUser: User? { get }
    
    func login(username: String, password: String, completion: @escaping (Result<User, Error>) -> Void)
    func logout()
    func authenticateWithBiometrics(completion: @escaping (Result<User, Error>) -> Void)
}

class AuthService: AuthServiceProtocol {
    private let keychainService: KeychainServiceProtocol
    private let networkService: NetworkServiceProtocol
    
    private(set) var currentUser: User?
    
    var isAuthenticated: Bool {
        return keychainService.hasAccessToken
    }
    
    init(
        keychainService: KeychainServiceProtocol = KeychainService(),
        networkService: NetworkServiceProtocol = NetworkService()
    ) {
        self.keychainService = keychainService
        self.networkService = networkService
        
        if let token = keychainService.accessToken {
            print("[AuthService] 初始化时检测到token，设置到networkService")
            networkService.setAuthToken(token)
        } else {
            print("[AuthService] 初始化时未检测到token")
        }
    }
    
    func login(username: String, password: String, completion: @escaping (Result<User, Error>) -> Void) {
        print("[AuthService] 开始登录，用户名: \(username)")
        networkService.request(
            endpoint: GitHubAPI.authenticate(username: username, password: password),
            responseType: User.self
        ) { [weak self] result in
            switch result {
            case .success(let user):
                print("[AuthService] 登录成功，用户: \(user)")
                self?.currentUser = user
                completion(.success(user))
            case .failure(let error):
                print("[AuthService] 登录失败，错误: \(error)")
                completion(.failure(error))
            }
        }
    }
    
    func logout() {
        print("[AuthService] 注销，清除token和当前用户")
        keychainService.deleteAccessToken()
        networkService.setAuthToken(nil)
        currentUser = nil
    }
    
    func authenticateWithBiometrics(completion: @escaping (Result<User, Error>) -> Void) {
        print("[AuthService] 开始生物识别认证")
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Authenticate to access your GitHub account"
            print("[AuthService] 设备支持生物识别，弹出认证框")
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { [weak self] success, authError in
                DispatchQueue.main.async {
                    if success {
                        print("[AuthService] 生物识别认证成功，尝试用保存的用户名密码自动登录")
                        guard let username = self?.keychainService.username,
                              let password = self?.keychainService.password else {
                            print("[AuthService] 没有保存的用户名或密码")
                            completion(.failure(AuthError.noSavedCredentials))
                            return
                        }
                        
                        self?.login(username: username, password: password) { result in
                            completion(result)
                        }
                    } else {
                        if let error = authError {
                            print("[AuthService] 生物识别认证失败，错误: \(error)")
                            completion(.failure(error))
                        } else {
                            print("[AuthService] 生物识别认证失败，未知错误")
                            completion(.failure(AuthError.unknown))
                        }
                    }
                }
            }
        } else {
            print("[AuthService] 设备不支持生物识别，错误: \(String(describing: error))")
            completion(.failure(AuthError.biometricsNotAvailable))
        }
    }
}

enum AuthError: Error {
    case biometricsNotAvailable
    case noSavedCredentials
    case unknown
}    
