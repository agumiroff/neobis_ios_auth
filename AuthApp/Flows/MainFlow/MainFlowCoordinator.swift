//
//  MainFlowCoordinator.swift
//  AuthApp
//
//  Created by G G on 26.05.2023.
//

import Foundation
import UIKit
import RxSwift
import SwiftUI
import Combine

protocol ModalViewDelegate: AnyObject {
    func closeModalView()
}

final class MainFlowCoordinator: Coordinator, ModalViewDelegate {
    
    var type: CoordinatorType = .main
    var navigationController: UINavigationController
    private let disposeBag = DisposeBag()
    private var cancellable = Set<AnyCancellable>()
    var delegate: CoordinatorFinishDelegate
    
    init(navigationController: UINavigationController, delegate: CoordinatorFinishDelegate) {
        self.navigationController = navigationController
        self.delegate = delegate
    }
    
    func start() {
        showWelcomeScreen()
    }
    
    func finish() {
        delegate.coordinatorDidFinish(childCoordinator: self)
    }
    
    private func showWelcomeScreen() {
        let module = WelcomeModuleAssembly.buildModule(dependencies: .init(), payload: .init())
        let view = module.view
        module.output
            .subscribe(onNext: {[weak self] event in
                guard let self = self else { return }
                switch event {
                case .routeToLogin:
                    self.finish()
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
                    break
                }
            })
            .disposed(by: disposeBag)
        
        navigationController.pushViewController(view, animated: true)
    }
    
    
    
    private func showModalView(_ message: String) {
        let view = UIViewController()
        
        view.view.backgroundColor = .clear
        view.view.isOpaque = false
        view.modalPresentationStyle = .overCurrentContext
        
        self.navigationController.present(view, animated: false)
    }
    
    func closeModalView() {
        self.navigationController.presentedViewController?.dismiss(animated: false)
    }
}
