//
//  Coordinator.swift
//  GitHubClientApp
//
//  Created by Chuan on 2025/5/22.
//

import Foundation
import UIKit

protocol Coordinator: AnyObject {
    func start()
}

class BaseCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    func start() {
        fatalError("Start method should be implemented")
    }
}    
