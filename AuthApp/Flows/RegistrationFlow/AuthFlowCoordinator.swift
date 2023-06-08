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
    private var model = UserModelAPI(firstName: "", secondName: "", dateOfBirth: "", email: "", password: "")
    // MARK: Methods
    func start() {
        showEmailVerificationScreen()
    }
    
    func finish() {
        delegate.coordinatorDidFinish(childCoordinator: self)
    }
    
    // MARK: - Init
    init(navigationController: UINavigationController, delegate: CoordinatorFinishDelegate) {
        self.navigationController = navigationController
        self.delegate = delegate
        
        DeepLinkParser.shared.currentDeepLink
            .sink { [weak self] value in
                guard let self else { return }
                self.handleDeepLink(value)
            }
            .store(in: &cancellables)
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
    
    private func showWelcomeScreen() {
        let module = WelcomeModuleAssembly.buildModule(dependencies: .init(), payload: .init())
        let view = module.view
        module.output
            .sink { [weak self] event in
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
                case let .emailVerified(email):
                    self.model.email = email
                case .finishFlow:
                    self.navigationController.presentedViewController?.dismiss(animated: false)
                    self.finish()
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
                guard let self else { return }
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
                guard let self else { return }
                switch event {
                case let .additionalInfoAdded(userModel):
                    self.showPasswordScreen(userModel: userModel)
                case .registerFailed:
                    self.finish()
                }
            }
            .store(in: &cancellables)
        
        navigationController.pushViewController(view, animated: false)
    }
    
    private func showPasswordScreen(userModel: UserModelAPI) {
        let module = PasswordModuleAssembly.buildModule(dependencies: .init(), payload: .init(userModel: userModel))
        let view = module.view
        module.output
            .sink { [weak self] event in
                guard let self else { return }
                switch event {
                case .backRouteAsked:
                    self.navigationController.popViewController(animated: true)
                case .userRegistered:
                    self.finish()
                }
            }
            .store(in: &cancellables)
        
        navigationController.pushViewController(view, animated: true)
    }
}

// MARK: - deepLink handling
extension AuthFlowCoordinator {
    private func handleDeepLink(_ deepLink: DeepLinkModel?) {
        guard let deepLink = deepLink else { return }
        let host = deepLink.host
        let components = deepLink.components
        let parameters = deepLink.parameters
        print(host)
        print(components)
        print(parameters)
        switch host {
        case "additionalInfo":
            showAdditionalInfoScreen()
        case "login":
            showLoginScreen()
        case "welcome":
            showWelcomeScreen()
        default: break
        }
        
        if !components.isEmpty {
            for component in components {
                switch component {
                case "additionalInfo":
                    showAdditionalInfoScreen()
                case "login":
                    showLoginScreen()
                case "welcome":
                    showWelcomeScreen()
                default: break
                }
            }
        }
    }
}
