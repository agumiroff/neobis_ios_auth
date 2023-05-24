//
//  Coordinator.swift
//  AuthApp
//
//  Created by G G on 25.05.2023.
//

import Foundation

class AppCoordinator {
    var navigationController: AppNavigation
    
    init(navigationController: AppNavigation) {
        self.navigationController = navigationController
        navigationController.coordinator = self
    }
    
    func start() {}
}
