//
//  MainFlowCoordinator.swift
//  AuthApp
//
//  Created by G G on 09.06.2023.
//

import UIKit

final class MainFlowCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    var delegate: CoordinatorFinishDelegate
    
    var type: CoordinatorType = .main
    
    func start() {
        let view = UIViewController()
        view.view.backgroundColor = .orange
        navigationController.viewControllers = [view]
    }
    
    init(navigationController: UINavigationController,
         delegate: CoordinatorFinishDelegate) {
        self.navigationController = navigationController
        self.delegate = delegate
    }
}
