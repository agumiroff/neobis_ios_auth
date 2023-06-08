//
//  Coordinator.swift
//  AuthApp
//
//  Created by G G on 25.05.2023.
//

import Foundation
import UIKit

final class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: AppNavigation) {
        self.navigationController = navigationController
        navigationController.coordinator = self
    }
    
    func start() {}
    
    private func startLoginFlow() {
        
        let view = WelcomeViewController()
        
        navigationController.viewControllers = []
    }
}
