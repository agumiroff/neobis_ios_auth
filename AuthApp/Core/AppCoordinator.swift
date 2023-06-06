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
    
    func deepLinkRedirect() {
        startAuthFlow()
    }
    
    func start(with option: DeepLinkType) {
        switch option {
        case .additionalInfo:
            childCoordinators.last?.start(with: option)
        case .login:
            childCoordinators.last?.start(with: option)
        }
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
}

extension AppCoordinator: CoordinatorFinishDelegate {
    
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        childCoordinators = childCoordinators.filter({ $0.type != childCoordinator.type })
        switch childCoordinator.type {
        case .app:
            navigationController.viewControllers.removeAll()
        case .registration:
            navigationController.viewControllers.removeAll()
        case .login:
            navigationController.viewControllers.removeAll()
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
