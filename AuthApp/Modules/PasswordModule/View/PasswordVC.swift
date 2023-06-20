//
//  PasswordVC.swift
//  AuthApp
//
//  Created by G G on 07.06.2023.
//

import UIKit
import SnapKit
import Combine

final class PasswordVC<PasswordViewModel: ViewModel>: BaseViewController where PasswordViewModel.State == PasswordState, PasswordViewModel.Event == PasswordEvent, PasswordViewModel.Output == PasswordOutput {
        
    // MARK: - Properties
    private let passwordField = BaseTextField(title: Constants.passwordFieldTitle, type: .password)
    private let passwordConfirmField = BaseTextField(title: Constants.passwordFieldTitle, type: .password)
    private let hidePassword = UIButton()
    private let hidePasswordConfirm = UIButton()
    private let capitalLetterLabel = UILabel()
    private let numberLabel = UILabel()
    private let specialSymbolLabel = UILabel()
    private let passwordsEqualLabel = UILabel()
    private let filledButton = FilledButton(title: Constants.filledButtonTitle)
    private let viewModel: PasswordViewModel
    private var isSubmitEnabled = CurrentValueSubject<Bool, Never>(false)
    private var cancellables = Set<AnyCancellable>()
    private let type: ViewControllerType
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - SetupUI
    override func setupUI() {
        super.setupUI()
        
        passwordFieldSetup()
        passwordConfirmFieldSetup()
        capitalLetterLabelSetup()
        numberLabelSetup()
        specialSymbolLabelSetup()
        passwordsEqualLabelSetup()
        addTextFieldObserver()
        hidePasswordButtonSetup()
        hidePasswordConfirmButtonSetup()
        filledButtonSetup()
    }
    
    init(viewModel: PasswordViewModel, type: ViewControllerType) {
        self.viewModel = viewModel
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func navigationSetup() {
        navigationController?.isToolbarHidden = false
        navigationController?.isNavigationBarHidden = false
        
        navigationItem.title = type == .registration ? Constants.registrationTitle : Constants.resetTitle
        let backButtonImage = UIImage(named: Constants.backButtonImageName)?.withRenderingMode(.alwaysOriginal)
        let backButton = UIBarButtonItem(image: backButtonImage,
                                         style: .plain,
                                         target: self,
                                         action: #selector(backAction))
        navigationItem.leftBarButtonItem = backButton
    }

    private func passwordFieldSetup() {
        contentView.addSubview(passwordField)
               
        passwordField.isSecureTextEntry = true
                
        passwordField.snp.makeConstraints { make in
            make.top.equalToSuperview()
                .inset(Constants.loginFieldTop)
            make.horizontalEdges.equalToSuperview()
                .inset(Constants.horizontalInsets)
        }
    }
    
    private func passwordConfirmFieldSetup() {
        contentView.addSubview(passwordConfirmField)
               
        passwordConfirmField.isSecureTextEntry = true
        
        passwordConfirmField.snp.makeConstraints { make in
            make.top.equalTo(passwordField.snp.bottom)
                .offset(Constants.passwordFieldTop)
            make.horizontalEdges.equalToSuperview()
                .inset(Constants.horizontalInsets)
        }
    }
    
    private func capitalLetterLabelSetup() {
        contentView.addSubview(capitalLetterLabel)
        
        capitalLetterLabel.text = Constants.capitalLetterLabelText
        capitalLetterLabel.textColor = UIColor(hexString: Constants.textDarkGray)
        
        capitalLetterLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
                .inset(Constants.horizontalInsets)
            make.top.equalTo(passwordConfirmField.snp.bottom)
                .offset(Constants.validatingLabelTop)
        }
    }
    
    private func numberLabelSetup() {
        contentView.addSubview(numberLabel)
        
        numberLabel.text = Constants.numberLabelText
        numberLabel.textColor = UIColor(hexString: Constants.textDarkGray)
        
        numberLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
                .inset(Constants.horizontalInsets)
            make.top.equalTo(capitalLetterLabel.snp.bottom)
        }
    }
    
    private func specialSymbolLabelSetup() {
        contentView.addSubview(specialSymbolLabel)
        
        specialSymbolLabel.text = Constants.specialSymbolLabelText
        specialSymbolLabel.textColor = UIColor(hexString: Constants.textDarkGray)
        
        specialSymbolLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
                .inset(Constants.horizontalInsets)
            make.top.equalTo(numberLabel.snp.bottom)
        }
    }
    
    private func passwordsEqualLabelSetup() {
        contentView.addSubview(passwordsEqualLabel)
        
        passwordsEqualLabel.text = Constants.passwordsEqualLabelText
        passwordsEqualLabel.textColor = UIColor(hexString: Constants.textDarkGray)
        
        passwordsEqualLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
                .inset(Constants.horizontalInsets)
            make.top.equalTo(specialSymbolLabel.snp.bottom)
        }
    }
    
    private func hidePasswordButtonSetup() {
        passwordField.addSubview(hidePassword)
        
        hidePassword.setImage(UIImage(named: Constants.hidePasswordImageName), for: .normal)
        hidePassword.addTarget(self, action: #selector(hidePasswordText), for: .touchUpInside)
        
        hidePassword.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
                .inset(Constants.hidePasswordButtonTrailing)
            make.centerY.equalToSuperview()
        }
    }
    
    private func hidePasswordConfirmButtonSetup() {
        passwordConfirmField.addSubview(hidePasswordConfirm)
        
        hidePasswordConfirm.setImage(UIImage(named: Constants.hidePasswordImageName), for: .normal)
        hidePasswordConfirm.addTarget(self, action: #selector(hidePasswordConfirmText), for: .touchUpInside)
        
        hidePasswordConfirm.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
                .inset(Constants.hidePasswordButtonTrailing)
            make.centerY.equalToSuperview()
        }
    }
    
    private func filledButtonSetup() {
        contentView.addSubview(filledButton)
        
        filledButton.addTarget(self, action: #selector(registerUser), for: .touchUpInside)
        isSubmitEnabled
            .sink { [weak self] in
                self?.filledButton.isEnabled = $0
                self?.filledButton.updateAppearance(isEnabled: $0)
            }
            .store(in: &cancellables)
        
        filledButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
                .inset(Constants.horizontalInsets)
            make.top.equalTo(passwordsEqualLabel.snp.bottom)
                .offset(Constants.filledButtonTop)
            make.bottom.equalToSuperview()
        }
    }
    
    @objc private func backAction() {
        viewModel.sendEvent(.goToPreviousScreen)
    }
    
    @objc private func hidePasswordText() {
        let isSecure = passwordField.isSecureTextEntry
        passwordField.isSecureTextEntry.toggle()
        hidePassword.setImage(UIImage(named: isSecure ? Constants.hiddenPasswordImageName : Constants.hidePasswordImageName), for: .normal)
    }
    
    @objc private func hidePasswordConfirmText() {
        let isSecure = passwordConfirmField.isSecureTextEntry
        passwordConfirmField.isSecureTextEntry.toggle()
        hidePasswordConfirm.setImage(UIImage(named: isSecure ? Constants.hiddenPasswordImageName : Constants.hidePasswordImageName), for: .normal)
    }
    
    @objc private func registerUser() {
        guard let password = passwordField.text else { return }
        viewModel.sendEvent(type == .registration ? .registerUser(password) : .goToPreviousScreen)
    }
    
    @objc private func addTextFieldObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(passwordTextDidChange),
                                               name: UITextField.textDidChangeNotification, object: nil)
    }
    
    @objc private func passwordTextDidChange() {
        var containsUppercasedLetters = false
        var containsSymbols = false
        var containsDecimalDigits = false
        var passwordsEqual = false
        let customCharacterSet = CharacterSet(charactersIn: Constants.customCharacterString)
        
        guard let text = passwordField.text else { return }
        if text.rangeOfCharacter(from: CharacterSet.uppercaseLetters) != nil {
            containsUppercasedLetters = true
            capitalLetterLabel.textColor = UIColor(hexString: Constants.mainBlueColor)
        } else {
            containsUppercasedLetters = false
            capitalLetterLabel.textColor = UIColor(hexString: Constants.textDarkGray)
        }
        
        if text.rangeOfCharacter(from: customCharacterSet) != nil {
            containsSymbols = true
            specialSymbolLabel.textColor = UIColor(hexString: Constants.mainBlueColor)
        } else {
            containsSymbols = false
            specialSymbolLabel.textColor = UIColor(hexString: Constants.textDarkGray)
        }
        
        if text.rangeOfCharacter(from: CharacterSet.decimalDigits) != nil {
            containsDecimalDigits = true
            numberLabel.textColor = UIColor(hexString: Constants.mainBlueColor)
        } else {
            numberLabel.textColor = UIColor(hexString: Constants.textDarkGray)
            containsDecimalDigits = false
        }
        
        passwordsEqual = passwordField.text == passwordConfirmField.text
        passwordsEqualLabel.textColor = UIColor(hexString: passwordsEqual ? Constants.mainBlueColor : Constants.textDarkGray)
        
        if containsUppercasedLetters && containsSymbols && containsDecimalDigits && passwordsEqual && text.count > Constants.minimumPasswordLength {
            isSubmitEnabled.send(true)
        } else {
            isSubmitEnabled.send(false)
        }
    }
}


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
    static let backButtonTrailingInset = 16.0
    static let filledButtonBottomInset = 24.0
    
    // Strings
    static let transparentButtonTitle = "Забыли пароль?"
    static let filledButtonTitle = "Войти"
    static let capitalLetterLabelText = "• Заглавная буква"
    static let numberLabelText = "• Цифры"
    static let specialSymbolLabelText = "• Специальные символы"
    static let passwordsEqualLabelText = "• Совпадение пароля"
    static let hidePasswordImageName = "passHide"
    static let hiddenPasswordImageName = "passHidden"
    static let backButtonImageName = "backButton"
    static let customCharacterString = "!@#$%ˆ&*˜"
    static let minimumPasswordLength = 6
    static let registrationTitle = "Регистрация"
    static let resetTitle = "Сброс пароля"
}
