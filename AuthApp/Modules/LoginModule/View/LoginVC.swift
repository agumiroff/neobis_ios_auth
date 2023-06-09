//
//  ViewController.swift
//  authApp
//
//  Created by G G on 24.05.2023.
//

import UIKit
import SnapKit
import Combine

final class LoginVC: BaseViewController {
    
    // MARK: - Properties
    private var cancellables = Set<AnyCancellable>()
    private let viewModel: any LoginVM
    private let smileImage = UIImageView()
    private let hidePasswordButton = UIButton()
    private var loginField = BaseTextField(title: Constants.loginFieldText, type: .email)
    private let passwordField = BaseTextField(title: Constants.passwordFieldTitle, type: .password)
    private let validatingLabel = UILabel()
    private let filledButton = FilledButton(title: Constants.filledButtonTitle)
    private let transparentButton = UIButton()
    private let spacer = UIView()
    private var isLoginValid = CurrentValueSubject<Bool, Never>(false)
    private var isPasswordValid = CurrentValueSubject<Bool, Never>(false)
    private var isAuthEnabled: AnyPublisher<Bool, Never> {
        return Publishers.CombineLatest(isLoginValid, isPasswordValid)
            .map { $0 && $1 }
            .eraseToAnyPublisher()
    }
    
    // MARK: - init
    init(viewModel: any LoginVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        subscribe()
    }
    
    // MARK: - SetupUI
    override func setupUI() {
        super.setupUI()
        
        smileImageSetup()
        loginFieldSetup()
        passwordFieldSetup()
        validatingLabelSetup()
        filledButtonSetup()
        spacerSetup()
        transparentButtonSetup()
    }
}

// MARK: - SetupViews
extension LoginVC {
    
    private func smileImageSetup() {
        contentView.addSubview(smileImage)
        
        smileImage.image = UIImage(named: Constants.smileImageName)
        
        smileImage.snp.makeConstraints { make in
            make.top.equalToSuperview()
                .inset(Constants.smileImageVerticalInset)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(Constants.smileImageSideSize)
        }
    }
    
    private func loginFieldSetup() {
        contentView.addSubview(loginField)
        
        NotificationCenter.default
            .addObserver(self, selector: #selector(loginDidChange),
                         name: UITextField.textDidChangeNotification,
                         object: loginField)
        
        loginField.layer.cornerRadius = Constants.submitButtonCornerRadius
        loginField.clipsToBounds = true
        loginField.layer.borderWidth = 1
        
        loginField.snp.makeConstraints { make in
            make.top.equalTo(smileImage.snp.bottom)
                .offset(Constants.loginFieldTop)
            make.horizontalEdges.equalToSuperview()
                .inset(Constants.horizontalInsets)
        }
    }
    
    private func passwordFieldSetup() {
        contentView.addSubview(passwordField)
               
        passwordField.isSecureTextEntry = true
        NotificationCenter.default
            .addObserver(self, selector: #selector(passwordDidChange),
                         name: UITextField.textDidChangeNotification,
                         object: passwordField)
        
        passwordField.layer.cornerRadius = Constants.submitButtonCornerRadius
        passwordField.clipsToBounds = true
        passwordField.layer.borderWidth = 1
        
        passwordField.snp.makeConstraints { make in
            make.top.equalTo(loginField.snp.bottom)
                .offset(Constants.passwordFieldTop)
            make.horizontalEdges.equalToSuperview()
                .inset(Constants.horizontalInsets)
        }
        
        hidePasswordButtonSetup()
    }
    
    private func hidePasswordButtonSetup() {
        passwordField.addSubview(hidePasswordButton)
        
        hidePasswordButton.setImage(UIImage(named: Constants.hidePasswordImage), for: .normal)
        hidePasswordButton.addTarget(self, action: #selector(hidePassword), for: .touchUpInside)
        
        hidePasswordButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
                .inset(Constants.hidePasswordButtonTrailing)
            make.centerY.equalToSuperview()
        }
    }
    
    private func validatingLabelSetup() {
        contentView.addSubview(validatingLabel)
        
        validatingLabel.textColor = .red
        validatingLabel.numberOfLines = 4
        
        validatingLabel.snp.makeConstraints { make in
            make.centerX.equalTo(passwordField.snp.centerX)
            make.top.equalTo(passwordField.snp.bottom)
                .offset(Constants.validatingLabelTop)
            make.horizontalEdges.equalToSuperview()
                .inset(Constants.horizontalInsets)
        }
    }
    
    private func filledButtonSetup() {
        contentView.addSubview(filledButton)
        
        filledButton.addTarget(self, action: #selector(filledButtonTapped), for: .touchUpInside)
        
        isAuthEnabled
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.filledButton.isEnabled = value
                self?.filledButton.updateAppearance(isEnabled: value)
            }
            .store(in: &cancellables)
        
        filledButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
                .inset(Constants.horizontalInsets)
            make.top.equalTo(validatingLabel.snp.bottom)
                .offset(Constants.filledButtonTop)
        }
    }
    
    private func spacerSetup() {
        contentView.addSubview(spacer)
        
        spacer.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(filledButton.snp.bottom)
            make.height.equalTo(Constants.transparentButtonTop)
        }
    }
    
    private func transparentButtonSetup() {
        contentView.addSubview(transparentButton)
        
        transparentButton.setTitle(Constants.transparentButtonTitle, for: .normal)
        transparentButton.tintColor = .black
        transparentButton.titleLabel?.font = UIFont(name: Constants.Font.gothamMedium,
                                                    size: Constants.Font.regular)
        transparentButton.setTitleColor(.black, for: .normal)
        transparentButton.addTarget(self, action: #selector(transparentButtonTapped), for: .touchUpInside)
        
        transparentButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
                .inset(Constants.horizontalInsets)
            make.top.equalTo(spacer.snp.bottom)
            make.bottom.equalToSuperview()
                .inset(Constants.transparentButtonBottom)
        }
    }
}

// MARK: - Methods
extension LoginVC {
    
    private func subscribe() {
        viewModel.state
            .sink { state in
                switch state {
                case .initial:
                    self.validatingLabel.text = ""
                    self.validatingLabel.isHidden = true
                    self.loginField.layer.borderColor = UIColor.clear.cgColor
                    self.passwordField.layer.borderColor = UIColor.clear.cgColor
                case .failure:
                    self.validatingLabel.text = Constants.loginFailedMessage
                    self.validatingLabel.isHidden = false
                    self.loginField.layer.borderColor = UIColor.red.cgColor
                    self.passwordField.layer.borderColor = UIColor.red.cgColor
                }
            }
            .store(in: &cancellables)
    }
    
    @objc private func loginDidChange(_ notification: Notification) {
        if let textField = notification.object as? UITextField {
            guard let validationResult = textField.text?.isValidEmail() else { return }
            isLoginValid.send(validationResult)
            self.validatingLabel.text = validationResult ? "" : Constants.emailCheckFailed
            self.validatingLabel.isHidden = validationResult ? true : false
            self.viewModel.sendEvent(.askedForReset)
        }
    }
    
    @objc private func passwordDidChange(_ notification: Notification) {
        if let textField = notification.object as? UITextField {
            guard let validationResult = textField.text?.isValidPassword() else { return }
            isPasswordValid.send(validationResult)
            self.validatingLabel.text = validationResult ? "" : Constants.passCheckFailed
            self.validatingLabel.isHidden = validationResult ? true : false
            self.viewModel.sendEvent(.askedForReset)
        }
    }
    
    @objc private func filledButtonTapped() {
        guard let login = loginField.text,
              let password = passwordField.text else { return }
        viewModel.sendEvent(.askedForLogin(login: login, password: password))
    }
    
    @objc private func transparentButtonTapped() {
        viewModel.sendEvent(.askedForRecovery)
    }
}

extension LoginVC {
    @objc func hidePassword() {
        let isSecure = passwordField.isSecureTextEntry
        passwordField.isSecureTextEntry.toggle()
        hidePasswordButton.setImage(UIImage(named: isSecure ? Constants.hiddenPasswordImage :
                                                Constants.hidePasswordImage), for: .normal)
    }
}

// MARK: - Constraints and constants
fileprivate extension Constants {
    
    // Constraints
    static let smileImageVerticalInset = 32.0
    static let smileImageHorizontalInsets = 0.0
    static let smileImageSideSize = 120.0
    
    static let loginFieldTop = 40.0
    
    static let passwordFieldTop = 24.0
    
    static let filledButtonCornerRadius = 16.0
    static let filledButtonTop = 31.0
    
    static let validatingLabelTop = 16.0
    
    static var transparentButtonTop = 198.0
    static let transparentButtonBottom = 16.0
    
    // Strings
    static let transparentButtonTitle = "Забыли пароль?"
    static let filledButtonTitle = "Войти"
    static let loginFailedMessage = "Неверный логин или пароль"
}
