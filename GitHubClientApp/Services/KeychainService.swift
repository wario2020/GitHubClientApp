//
//  KeychainService.swift
//  GitHubClientApp
//
//  Created by Chuan on 2025/5/22.
//

import Foundation
import KeychainSwift

protocol KeychainServiceProtocol {
    var hasAccessToken: Bool { get }
    var accessToken: String? { get set }
    var username: String? { get set }
    var password: String? { get set }
    
    func deleteAccessToken()
}

class KeychainService: KeychainServiceProtocol {
    static let shared = KeychainService()
    
    private let keychain = KeychainSwift()
    private let accessTokenKey = "github_accessToken"
    private let usernameKey = "github_username"
    private let passwordKey = "github_password"
    
    var hasAccessToken: Bool {
        return accessToken != nil
    }
    
    var accessToken: String? {
        get {
            return keychain.get(accessTokenKey)
        }
        set {
            if let newValue = newValue {
                keychain.set(newValue, forKey: accessTokenKey)
            } else {
                keychain.delete(accessTokenKey)
            }
        }
    }
    
    var username: String? {
        get {
            return keychain.get(usernameKey)
        }
        set {
            if let newValue = newValue {
                keychain.set(newValue, forKey: usernameKey)
            } else {
                keychain.delete(usernameKey)
            }
        }
    }
    
    var password: String? {
        get {
            return keychain.get(passwordKey)
        }
        set {
            if let newValue = newValue {
                keychain.set(newValue, forKey: passwordKey)
            } else {
                keychain.delete(passwordKey)
            }
        }
    }
    
    func deleteAccessToken() {
        accessToken = nil
        username = nil
        password = nil
    }
}    
