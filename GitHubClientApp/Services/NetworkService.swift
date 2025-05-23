//
//  NetworkService.swift
//  GitHubClientApp
//
//  Created by Chuan on 2025/5/22.
//

import Foundation
import Alamofire

protocol NetworkServiceProtocol {
    func setAuthToken(_ token: String?)
    func request<T: Decodable>(endpoint: APIEndpoint, responseType: T.Type, completion: @escaping (Result<T, Error>) -> Void)
}

class NetworkService: NetworkServiceProtocol {
    private var authToken: String?
    
    func setAuthToken(_ token: String?) {
        self.authToken = token
    }
    
    func request<T: Decodable>(endpoint: APIEndpoint, responseType: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        var urlComponents = URLComponents()
        urlComponents.scheme = endpoint.scheme
        urlComponents.host = endpoint.host
        urlComponents.path = endpoint.path
        urlComponents.queryItems = endpoint.parameters
        
        guard let url = urlComponents.url else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        
        // 设置 headers
        endpoint.headers.forEach { key, value in
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        if let authToken = authToken {
            request.setValue("token \(authToken)", forHTTPHeaderField: "Authorization")
        }
        
        if let body = endpoint.body {
            request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: [])
        }
        
        AF.request(request)
            .validate()
            .responseDecodable(of: responseType) { response in
                switch response.result {
                case .success(let value):
                    completion(.success(value))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
}

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case decodingError
}
