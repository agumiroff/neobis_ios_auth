//
//  RegistrationFlowCoordinator.swift
//  AuthApp
//
//  Created by G G on 04.06.2023.
//

import Foundation
import UIKit
import Combine
import Moya
// 4bfg3w2g6xh@wuuvo.com
final class AuthFlowCoordinator: Coordinator {
    
    // MARK: - Properties
    var type: CoordinatorType = .auth
    private var cancellables = Set<AnyCancellable>()
    var navigationController: UINavigationController
    var delegate: CoordinatorFinishDelegate
    var childCoordinators: [Coordinator] = []
    private var model = UserModelAPI(firstName: "", secondName: "", dateOfBirth: "", phone: "")
    private let networkServiceProvider = MoyaProvider<NetworkRequest>()
    
    // MARK: Methods
    func start() {
        showWelcomeScreen()
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
    
    // WelcomeScreen
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
                    self.showEmailVerificationScreen(type: .registration)
                }
            }
            .store(in: &cancellables)
        
        navigationController.viewControllers = [view]
    }
    
    // EmailScreen
    private func showEmailVerificationScreen(type: ViewControllerType) {
        let module = EmailModuleAssembly.buildModule(dependencies: .init(), payload: .init(type: type))
        let view = module.view
        
        module.output
            .sink { [weak self] output in
                guard let self = self else { return }
                switch output {
                case .popView:
                    self.navigationController.popViewController(animated: true)
                case .emailDidSend:
                    self.showWelcomeScreen()
                    self.navigationController.presentedViewController?.dismiss(animated: false)
                }
            }
            .store(in: &cancellables)
        
        self.navigationController.pushViewController(view, animated: true)
    }
    
    // LoginScreen
    private func showLoginScreen() {
        let module = LoginModuleAssembly.buildModule(
            dependencies: .init(networkServiceProvider: networkServiceProvider),
            payload: .init()
        )
        let view = module.view
        module.output
            .sink { [weak self] event in
                guard let self else { return }
                switch event {
                case .authenticateUser:
                    break
                case .passwordRecovery:
                    self.showEmailVerificationScreen(type: .recovery)
                case .userSucessfullyLogedIn:
                    self.finish()
                }
            }
            .store(in: &cancellables)
        
        navigationController.pushViewController(view, animated: true)
    }
    
    // AdditionalInfoScreen
    private func showAdditionalInfoScreen(type: ViewControllerType) {
        let module = AdditionalInfoModuleAssembly.buildModule(
            dependencies: .init(networkServiceProvider: networkServiceProvider),
            payload: .init()
        )
        let view = module.view
        module.output
            .sink { [weak self] event in
                guard let self else { return }
                switch event {
                case let .additionalInfoAdded(userModel):
                    self.showPasswordScreen(userModel: userModel, type: type)
                case .registerFailed:
                    self.finish()
                }
            }
            .store(in: &cancellables)
        
        navigationController.pushViewController(view, animated: false)
    }
    
    // PasswordScreen
    private func showPasswordScreen(userModel: UserModelAPI, type: ViewControllerType) {
        let module = PasswordModuleAssembly.buildModule(
            dependencies: .init(networkServiceProvider: networkServiceProvider),
            payload: .init(userModel: userModel, type: type)
        )
        let view = module.view
        module.output
            .sink { [weak self] event in
                guard let self else { return }
                switch event {
                case .backRouteAsked:
                    self.navigationController.popViewController(animated: true)
                case .userRegistered:
                    self.showWelcomeScreen()
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
            showAdditionalInfoScreen(type: .registration)
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
                    showAdditionalInfoScreen(type: .registration)
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
