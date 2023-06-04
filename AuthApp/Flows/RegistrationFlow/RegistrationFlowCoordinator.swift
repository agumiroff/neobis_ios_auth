//
//  RegistrationFlowCoordinator.swift
//  AuthApp
//
//  Created by G G on 04.06.2023.
//

import Foundation
import UIKit
import Combine

final class RegistrationFlowCoordinator: Coordinator {
    
    // MARK: - Properties
    var type: CoordinatorType = .registration
    private var cancellables = Set<AnyCancellable>()
    var navigationController: UINavigationController
    var delegate: CoordinatorFinishDelegate
    
    // MARK: Methods
    func start() {
        showRegistrationScreen()
    }
    
    func finish() {
        delegate.coordinatorDidFinish(childCoordinator: self)
    }
    
    // MARK: - Init
    init(navigationController: UINavigationController, delegate: CoordinatorFinishDelegate) {
        self.navigationController = navigationController
        self.delegate = delegate
    }
    
    private func showRegistrationScreen() {
        let module = RegistrationModuleAssembly.buildModule(dependencies: .init(), payload: .init())
        let view = module.view
        
        module.output
            .sink { error in
                print(error)
            } receiveValue: { output in
                switch output {
                case .emailCheckPassed:
                    print("passed")
                case .showPopUp(text: _):
                    print("passed")
                case .popView:
                    self.navigationController.popViewController(animated: true)
                }
            }
            .store(in: &cancellables)

        
        self.navigationController.pushViewController(view, animated: true)
    }
}
