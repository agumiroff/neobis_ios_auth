//
//  Coordinator.swift
//  AuthApp
//
//  Created by G G on 25.05.2023.
//

import Foundation
import UIKit
import Combine


protocol ModalViewDelegate: AnyObject {
    func closeModalView()
}

final class AppCoordinator: Coordinator {
    
    // MARK: - Properties
    private var cancellabels = Set<AnyCancellable>()
    lazy var type: CoordinatorType = .app
    var navigationController: UINavigationController
    lazy var childCoordinators: [Coordinator] = []
    
    // MARK: - Init
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Methods
    func start() {
        startAuthFlow()
    }
    
    // MARK: - private Methods
    
}

// MARK: - Flows
extension AppCoordinator {
    private func startAuthFlow() {
        let coordinator = AuthFlowCoordinator(navigationController: navigationController, delegate: self)
        childCoordinators.append(coordinator)
        coordinator.start()
    }
    
    private func startMainFlow() {
        let coordinator = MainFlowCoordinator(navigationController: navigationController, delegate: self)
        childCoordinators.append(coordinator)
        coordinator.start()
    }
}

extension AppCoordinator: CoordinatorFinishDelegate {
    
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        childCoordinators = childCoordinators.filter({ $0.type != childCoordinator.type })
        switch childCoordinator.type {
        case .app:
            navigationController.viewControllers.removeAll()
        case .auth:
            navigationController.viewControllers.removeAll()
            startMainFlow()
        case .main:
            navigationController.viewControllers.removeAll()
        }
    }
}

extension AppCoordinator: ModalViewDelegate {
    func closeModalView() {
        self.navigationController.presentedViewController?.dismiss(animated: false)
    }
}
