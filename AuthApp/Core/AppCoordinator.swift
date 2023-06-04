//
//  Coordinator.swift
//  AuthApp
//
//  Created by G G on 25.05.2023.
//

import Foundation
import UIKit

final class AppCoordinator: Coordinator {
    var type: CoordinatorType = .app
    var navigationController: UINavigationController
    private lazy var childCoordinators: [Coordinator] = []
    
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        startLoginFlow()
    }
    
    private func startLoginFlow() {
        let coordinator = MainFlowCoordinator(navigationController: navigationController, delegate: self)
        childCoordinators.append(coordinator)
        coordinator.start()
    }
    
    private func startRegistrationFlow() {
        let coordinator = RegistrationFlowCoordinator(navigationController: navigationController, delegate: self)
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}

extension AppCoordinator: CoordinatorFinishDelegate  {
    
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        switch childCoordinator.type {
        case .app:
            navigationController.viewControllers.removeAll()
        case .registration:
            navigationController.viewControllers.removeAll()
        case .login:
            navigationController.viewControllers.removeAll()
            startRegistrationFlow()
        case .main:
            navigationController.viewControllers.removeAll()
        }
    }
}
