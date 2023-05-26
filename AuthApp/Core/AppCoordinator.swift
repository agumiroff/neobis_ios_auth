//
//  Coordinator.swift
//  AuthApp
//
//  Created by G G on 25.05.2023.
//

import Foundation
import UIKit

final class AppCoordinator: Coordinator {
    var navigationController: Navigation
    private lazy var childCoordinators: [Coordinator] = []
    
    init(navigationController: Navigation) {
        self.navigationController = navigationController
        self.navigationController.coordinator = self
    }
    
    func start() {
        startLoginFlow()
    }
    
    private func startLoginFlow() {
        let mainCoordinator = MainFlowCoordinator(navigationController: navigationController)
        childCoordinators.append(mainCoordinator)
        mainCoordinator.start()
    }
}
