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
    
    var navigationController: Navigation
    private let disposeBag = DisposeBag()
    private var cancellable = Set<AnyCancellable>()
    
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
        let module = RegistrationModuleAssembly.buildModule(dependencies: .init(), payload: .init())
        let view = module.view
        module.output
            .eraseToAnyPublisher()
            .sink { error in
                print(error)
            } receiveValue: { event in
                switch event {
                case .emailCheckPassed:
                    print("passed")
                case let .showPopUp(message):
                    self.showModalView(message)
                case .popView:
                    self.navigationController.popViewController(animated: true)
                }
            }
            .store(in: &cancellable)
        
        let hostedView = UIHostingController(rootView: view)
        navigationController.pushViewController(hostedView, animated: true)
    }
    
    private func showModalView(_ message: String) {
        let view: UIViewController = UIHostingController(rootView: ModalView(notificationText: message, delegate: self))
        
        view.view.backgroundColor = .clear
        view.view.isOpaque = false
        view.modalPresentationStyle = .overCurrentContext
        
        self.navigationController.present(view, animated: false)
    }
    
    func closeModalView() {
        self.navigationController.presentedViewController?.dismiss(animated: false)
    }
}
