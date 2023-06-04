//
//  RegistrationViewController.swift
//  AuthApp
//
//  Created by G G on 04.06.2023.
//

import Foundation
import UIKit
import Combine
import SnapKit

class RegistrationViewController: BaseViewController {
    
    // MARK: - Properties
    private var cancellabels = Set<AnyCancellable>()
    private let containerView = ContainerView()
    private let viewModel: RegistrationViewModel
    
    init(viewModel: RegistrationViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - loadView
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
    }
    
    override func setupUI() {
        super.setupUI()
        containerSetup()
        navigationSetup()
        subscribe()
    }
    
    private func containerSetup() {
        contentView.addSubview(containerView)
        
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    // MARK: - viewWillDisappear
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.isToolbarHidden = true
        navigationController?.isNavigationBarHidden = true
    }
        
    override func navigationSetup() {
        navigationController?.isToolbarHidden = false
        navigationController?.isNavigationBarHidden = false
        
        navigationItem.title = "Регистрация"
        let backButtonImage = UIImage(named: "backButton")?.withRenderingMode(.alwaysOriginal)
        let backButton = UIBarButtonItem(image: backButtonImage,
                                         style: .plain,
                                         target: self,
                                         action: #selector(backAction))
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    @objc private func backAction() {
        viewModel.sendEvent(.routeBack)
    }
}

extension RegistrationViewController {
    enum State {
        case emailVerifying
        case error
        case emailCheckSuccess
        case waitForFillingAdditionalInfo
        case waitForPasswordEntering
    }
    
    private func subscribe() {
        containerView.event
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let self = self else { return }
                switch event {
                case let .validateEmail(email):
                    self.viewModel.sendEvent(.checkEmail(email: email))
                case let .checkEmail(email):
                    self.viewModel.sendEvent(.checkEmail(email: email))
                }
            }
            .store(in: &cancellabels)
        
        viewModel.state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self = self else { return }
                switch state {
                case .initial:
                    self.containerView.renderUI(.emailVerifying)
                case .loading:
                    break
                case .waitForEmailInput:
                    self.containerView.renderUI(.emailVerifying)
                case .emailValidationFailed:
                    self.containerView.renderUI(.error)
                case .emailCheckSuccessfull:
                    self.containerView.renderUI(.emailCheckSuccess)
                case .emailCheckFailed:
                    self.containerView.renderUI(.error)
                }
            }
            .store(in: &cancellabels)
    }
}
