//
//  MainFlowCoordinator.swift
//  AuthApp
//
//  Created by G G on 26.05.2023.
//

import Foundation
import UIKit
import RxSwift

final class MainFlowCoordinator: Coordinator {
    
    var navigationController: Navigation
    private let disposeBag = DisposeBag()
    
    init(navigationController: Navigation) {
        self.navigationController = navigationController
    }
    
    func start() {
        showWelcomeScreen()
    }
    
    private func showWelcomeScreen() {
        let module = WelcomeModuleAssembly.buildModule(dependencies: .init(), payload: .init())
        let view = module.view
        module.output
            .subscribe(onNext: {[weak self] event in
                guard let self = self else { return }
                switch event {
                case .routeToLogin:
                    self.showRegistrationScreen()
                case .registerNewUser:
                    self.showLoginScreen()
                }
            })
            .disposed(by: disposeBag)
        
        navigationController.viewControllers = [view]
    }
    
    private func showLoginScreen() {
        let module = LoginModuleAssembly.buildModule(dependencies: .init(), payload: .init())
        let view = module.view
        module.output
            .subscribe(onNext: {[weak self] event in
                guard let self = self else { return }
                switch event {
                case .authenticateUser:
                    break
                case .passwordRecovery:
                    self.showRegistrationScreen()
                }
            })
            .disposed(by: disposeBag)
        
        navigationController.pushViewController(view, animated: true)
    }
    
    private func showRegistrationScreen() {
        print("showRegistrationScreen")
    }
}
