//
//  Repository.swift
//  GitHubClientApp
//
//  Created by Chuan on 2025/5/22.
//

import Foundation

struct Repository: Codable {
    let id: Int
    let name: String
    let fullName: String
    let description: String?
    let htmlUrl: String
    let stargazersCount: Int
    let forksCount: Int
    let language: String?
    let owner: User
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case fullName = "full_name"
        case description
        case htmlUrl = "html_url"
        case stargazersCount = "stargazers_count"
        case forksCount = "forks_count"
        case language
        case owner
    }
}
