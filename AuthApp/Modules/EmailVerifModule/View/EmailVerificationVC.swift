//
//  RegistrationView.swift
//  AuthApp
//
//  Created by G G on 29.05.2023.
//

import Foundation
import Combine
import SnapKit

final class EmailVerificationVC: BaseViewController {
    
    // MARK: - Properties
    private lazy var cancellables = Set<AnyCancellable>()
    private let smileImage = UIImageView()
    private let welcomeLabel = UILabel()
    private let emailField = BaseTextField(title: Constants.loginFieldText, type: .email)
    private let validatingLabel = UILabel()
    private let filledButton = FilledButton(title: "close")
    var event: AnyPublisher<EmailEvent, Never> {
        _event.eraseToAnyPublisher()
    }
    private let _event = PassthroughSubject<EmailEvent, Never>()
    private let viewModel: any EmailViewModel
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Init
    init(viewModel: EmailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
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
    override func setupUI() {
        super.setupUI()
        navigationSetup()
        welcomeLabelSetup()
        smileImageSetup()
        emailFieldSetup()
        validatingLabelSetup()
        filledButtonSetup()
        subscribe()
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
}

// MARK: - SetupViews Methods
extension EmailVerificationVC {
    
    private func smileImageSetup() {
        contentView.addSubview(smileImage)
        
        smileImage.image = UIImage(named: Constants.smileImageName)
        
        smileImage.snp.makeConstraints { make in
            make.top.equalToSuperview()
                .inset(Constants.smileImageTopInset)
            make.trailing.equalToSuperview()
                .inset(Constants.smileImageTrailingInset)
        }
    }
    
    private func welcomeLabelSetup() {
        contentView.addSubview(welcomeLabel)
        
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
        contentView.addSubview(emailField)
        
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
        contentView.addSubview(validatingLabel)
        
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
        contentView.addSubview(filledButton)
        
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

// MARK: - Private methods
extension EmailVerificationVC {
    
    private func subscribe() {
        viewModel.state
            .sink { [weak self] state in
                guard let self = self else { return }
                self.configureUI(state)
            }
            .store(in: &cancellables)
    }
    
    private func configureUI(_ state: EmailVMState) {
        switch state {
        case .initial:
            filledButton.isEnabled = false
            filledButton.updateAppearance(isEnabled: false)
            emailField.layer.borderColor = UIColor.clear.cgColor
        case let .emailCheckResult(isValidEmail):
            self.validatingLabel.text = isValidEmail ? "" : Constants.emailCheckFailed
            self.validatingLabel.isHidden = isValidEmail
            self.emailField.layer.borderColor = isValidEmail ? UIColor.clear.cgColor : UIColor.red.cgColor
            filledButton.updateAppearance(isEnabled: isValidEmail)
        case .validationFailed:
            self.validatingLabel.text = Constants.validationError
            self.validatingLabel.isHidden = false
            self.emailField.layer.borderColor = UIColor.red.cgColor
        case .validationSuccess:
            PresentationService.present(text: self.emailField.text ?? "",
                                        from: self, action: { self.viewModel.sendEvent(.closeModal)})
        }
    }
    
    @objc private func emailDidChange(_ notification: Notification) {
        if let textField = notification.object as? UITextField {
            viewModel.sendEvent(.checkEmail(email: textField.text ?? ""))
        }
    }
    
    @objc private func buttonTapped() {
        viewModel.sendEvent(.validateEmail(email: self.emailField.text ?? ""))
    }
    
    @objc private func backAction() {
        viewModel.sendEvent(.routeBack)
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
