//
//  GitHubAPI.swift
//  GitHubClientApp
//
//  Created by Chuan on 2025/5/22.
//

//
//  GitHubAPI.swift
//  GitHubClientApp
//
//  Created by Chuan on 2025/5/22.
//

import Foundation

protocol APIEndpoint {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var parameters: [URLQueryItem]? { get }
    var headers: [String: String] { get }
    var body: [String: Any]? { get }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum GitHubAPI {
    case authenticate(username: String, password: String)
    case user
    case userRepositories
    case searchUsers(query: String)
    case userDetails(username: String)
}

extension GitHubAPI: APIEndpoint {
    var scheme: String {
        return "https"
    }
    
    var host: String {
        return "api.github.com"
    }
    
    var path: String {
        switch self {
        case .authenticate, .user:
            return "/user"
        case .userRepositories:
            return "/user/repos"
        case .searchUsers:
            return "/search/users"
        case .userDetails(let username):
            return "/users/\(username)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .authenticate, .user, .userRepositories, .searchUsers, .userDetails:
            return .get
        }
    }
    
    var parameters: [URLQueryItem]? {
        switch self {
        case .userRepositories:
            return [
                URLQueryItem(name: "sort", value: "updated"),
                URLQueryItem(name: "per_page", value: "30")
            ]
        case .searchUsers(let query):
            return [
                URLQueryItem(name: "q", value: query),
                URLQueryItem(name: "per_page", value: "30")
            ]
        default:
            return nil
        }
    }
    
    var headers: [String: String] {
        var headers = [
            "Accept": "application/vnd.github.v3+json",
            "Content-Type": "application/json"
        ]
        
        switch self {
        case .authenticate(let username, let password):
            let credentialData = "\(username):\(password)".data(using: .utf8)!
            let base64Credentials = credentialData.base64EncodedString()
            headers["Authorization"] = "Basic \(base64Credentials)"
        default:
            if let token = KeychainService.shared.accessToken {
                headers["Authorization"] = "token \(token)"
            }
        }
        
        return headers
    }
    
    var body: [String: Any]? {
        return nil
    }
}

// API响应模型
struct SearchUsersResponse: Codable {
    let total_count: Int
    let incomplete_results: Bool
    let items: [GitHubUser]
}

struct GitHubUser: Codable, Identifiable {
    let id: Int
    let login: String
    let avatar_url: String
    let html_url: String
    let type: String
    let name: String?
    let company: String?
    let blog: String?
    let location: String?
    let email: String?
    let bio: String?
    let public_repos: Int
    let public_gists: Int
    let followers: Int
    let following: Int
    let created_at: String
    let updated_at: String
}

struct GitHubRepository: Codable, Identifiable {
    let id: Int
    let name: String
    let full_name: String
    let html_url: String
    let description: String?
    let fork: Bool
    let stargazers_count: Int
    let watchers_count: Int
    let forks_count: Int
    let language: String?
    let updated_at: String
}
