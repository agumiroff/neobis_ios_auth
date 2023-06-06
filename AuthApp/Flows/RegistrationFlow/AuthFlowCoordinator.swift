//
//  RegistrationFlowCoordinator.swift
//  AuthApp
//
//  Created by G G on 04.06.2023.
//

import Foundation
import UIKit
import Combine

final class AuthFlowCoordinator: Coordinator {
    
    // MARK: - Properties
    var type: CoordinatorType = .registration
    private var cancellables = Set<AnyCancellable>()
    var navigationController: UINavigationController
    var delegate: CoordinatorFinishDelegate
    var childCoordinators: [Coordinator] = []
    
    // MARK: Methods
    func start() {
        showAdditionalInfoScreen()
    }
    
    func finish() {
        delegate.coordinatorDidFinish(childCoordinator: self)
    }
    
    func start(with option: DeepLinkType) {
        switch option {
        case .additionalInfo:
            showAdditionalInfoScreen()
        case .login:
            showLoginScreen()
        }
    }
    
    // MARK: - Init
    init(navigationController: UINavigationController, delegate: CoordinatorFinishDelegate) {
        self.navigationController = navigationController
        self.delegate = delegate
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
    
    private func showWelcomeScreen() {
        let module = WelcomeModuleAssembly.buildModule(dependencies: .init(), payload: .init())
        let view = module.view
        module.output
            .sink{ [weak self] event in
                guard let self = self else { return }
                switch event {
                case .signInUser:
                    self.showLoginScreen()
                case .signUpUser:
                    self.showEmailVerificationScreen()
                }
            }
            .store(in: &cancellables)
        
        navigationController.viewControllers = [view]
    }
    
    private func showEmailVerificationScreen() {
        let module = EmailModuleAssembly.buildModule(dependencies: .init(), payload: .init())
        let view = module.view
        
        module.output
            .sink { [weak self] output in
                guard let self = self else { return }
                switch output {
                case .showPopUp(text: _):
                    print("passed")
                case .popView:
                    self.navigationController.popViewController(animated: true)
                }
            }
            .store(in: &cancellables)
        
        self.navigationController.pushViewController(view, animated: true)
    }
    
    private func showLoginScreen() {
        let module = LoginModuleAssembly.buildModule(dependencies: .init(), payload: .init())
        let view = module.view
        module.output
            .sink { [weak self] event in
                guard let self = self else { return }
                switch event {
                case .authenticateUser:
                    break
                case .passwordRecovery:
                    break
                }
            }
            .store(in: &cancellables)
        
        navigationController.pushViewController(view, animated: true)
    }
    
    private func showAdditionalInfoScreen() {
        let module = AdditionalInfoModuleAssembly.buildModule(dependencies: .init(), payload: .init())
        let view = module.view
        module.output
            .sink { [weak self] event in
                guard let self = self else { return }
                switch event {
                case .additionalInfoAdded:
                    self.showPasswordScreen()
                }
            }
            .store(in: &cancellables)
        
        navigationController.viewControllers = [view]
    }
    
    private func showPasswordScreen() {
        print("route")
    }
}
