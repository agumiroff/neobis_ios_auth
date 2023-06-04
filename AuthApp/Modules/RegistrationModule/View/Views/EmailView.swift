//
//  RegistrationView.swift
//  AuthApp
//
//  Created by G G on 29.05.2023.
//

import Foundation
import Combine
import SnapKit

final class EmailView: UIView {
    
    // MARK: - Properties
    private lazy var cancellables = Set<AnyCancellable>()
    private let smileImage = UIImageView()
    private let welcomeLabel = UILabel()
    private let emailField = BaseTextField(title: Constants.loginFieldText)
    private let validatingLabel = UILabel()
    private let filledButton = FilledButton(title: "close")
    var isEmailValid = CurrentValueSubject<Bool, Never>(false)
    var event: AnyPublisher<Event, Never> {
        _event.eraseToAnyPublisher()
    }
    private let _event = PassthroughSubject<Event, Never>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - deinit
    deinit {
        cancellables.forEach { cancellable in
            cancellable.cancel()
        }
    }
    
    // MARK: - SetupUI
    private func setupUI() {
        welcomeLabelSetup()
        smileImageSetup()
        emailFieldSetup()
        validatingLabelSetup()
        filledButtonSetup()
        subscribe()
    }
}

// MARK: - SetupViews
extension EmailView {
    
    private func smileImageSetup() {
        addSubview(smileImage)
        
        smileImage.image = UIImage(named: Constants.smileImageName)
        
        smileImage.snp.makeConstraints { make in
            make.top.equalToSuperview()
                .inset(Constants.smileImageTopInset)
            make.trailing.equalToSuperview()
                .inset(Constants.smileImageTrailingInset)
        }
    }
    
    private func welcomeLabelSetup() {
        addSubview(welcomeLabel)
        
        welcomeLabel.text = Constants.welcomeLabelText
        welcomeLabel.font = UIFont(name: Constants.Font.gothamMedium,
                                   size: Constants.Font.largeTitle)
        welcomeLabel.textColor = UIColor(hexString: Constants.mainBlueColor)
        welcomeLabel.numberOfLines = 3
        
        welcomeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview()
                .inset(Constants.welcomeLabelLeadingInset)
            make.top.equalToSuperview()
                .offset(Constants.welcomeLabelTopInset)
        }
    }
    
    private func emailFieldSetup() {
        addSubview(emailField)
        
        NotificationCenter.default
            .addObserver(self, selector: #selector(emailDidChange),
                         name: UITextField.textDidChangeNotification,
                         object: emailField)
        
        emailField.layer.borderWidth = 1.0
        emailField.layer.cornerRadius = Constants.submitButtonCornerRadius
        emailField.clipsToBounds = true
        
        emailField.snp.makeConstraints { make in
            make.top.equalTo(welcomeLabel.snp.bottom)
                .offset(Constants.emailFieldTopOffset)
            make.horizontalEdges.equalToSuperview()
                .inset(Constants.horizontalInsets)
        }
    }
    
    private func validatingLabelSetup() {
        addSubview(validatingLabel)
        
        validatingLabel.text = ""
        validatingLabel.textColor = .red
        validatingLabel.numberOfLines = 4
        
        validatingLabel.snp.makeConstraints { make in
            make.centerX.equalTo(emailField.snp.centerX)
            make.top.equalTo(emailField.snp.bottom)
                .offset(Constants.validatingLabelTopOffset)
            make.horizontalEdges.equalToSuperview()
                .inset(Constants.horizontalInsets)
        }
    }
    
    private func filledButtonSetup() {
        addSubview(filledButton)
        
        filledButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        filledButton.snp.makeConstraints { make in
            make.top.equalTo(validatingLabel.snp.bottom)
                .offset(Constants.filledButtonTopOffset)
            make.horizontalEdges.equalToSuperview()
                .inset(Constants.horizontalInsets)
            make.bottom.equalToSuperview()
        }
    }
}

// MARK: - Methods
extension EmailView {
    
    private func subscribe() {
        isEmailValid
            .sink { [weak self] value in
                guard let self = self else { return }
                self.validatingLabel.text = value ? "" : Constants.emailCheckFailed
                self.validatingLabel.isHidden = value ? true : false
                self.emailField.layer.borderColor = value ? UIColor.clear.cgColor : UIColor.red.cgColor
                self.filledButton.isEnabled = value
            }
            .store(in: &cancellables)
    }
    
    @objc private func emailDidChange(_ notification: Notification) {
        if let textField = notification.object as? UITextField {
            _event.send(.checkEmail(email: textField.text ?? ""))
        }
    }
    
    @objc private func buttonTapped() {
        print("dsdsdsds")
    }
    
    @objc private func backAction() {}
}

extension EmailView {
    enum Event {
        case validateEmail(email: String)
        case checkEmail(email: String)
    }
}

fileprivate extension Constants {
    
    // Constraints
    static let smileImageTopInset: CGFloat = 13
    static let smileImageTrailingInset: CGFloat = 20
    static let welcomeLabelLeadingInset: CGFloat = 20
    static let welcomeLabelTopInset: CGFloat = 28
    static let emailFieldTopOffset: CGFloat = 60
    static let validatingLabelTopOffset: CGFloat = 16
    static let filledButtonTopOffset: CGFloat = 31
    
    // Strings
    static let warningLabel = "Данная почта уже зарегистрирована"
    static let validationError = "Данный email уже зарегистрирован"
}
