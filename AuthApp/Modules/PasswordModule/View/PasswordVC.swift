//
//  PasswordVC.swift
//  AuthApp
//
//  Created by G G on 07.06.2023.
//

import UIKit
import SnapKit
import Combine

class PasswordVC: BaseViewController {
    
    private let passwordField = BaseTextField(title: Constants.passwordFieldTitle, type: .password)
    private let passwordConfirmField = BaseTextField(title: Constants.passwordFieldTitle, type: .password)
    private let hidePassword = UIButton()
    private let hidePasswordConfirm = UIButton()
    private let capitalLetterLabel = UILabel()
    private let numberLabel = UILabel()
    private let specialSymbolLabel = UILabel()
    private let passwordsEqualLabel = UILabel()
    private let filledButton = FilledButton(title: "Далее")
    private let viewModel: any PasswordVM
    private var isSubmitEnabled = CurrentValueSubject<Bool, Never>(false)
    private var cancellables = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
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
    
    init(viewModel: any PasswordVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

extension PasswordVC {
    private func passwordFieldSetup() {
        contentView.addSubview(passwordField)
               
        passwordField.isSecureTextEntry = true
                
        passwordField.snp.makeConstraints { make in
            make.top.equalToSuperview()
                .inset(40)
            make.horizontalEdges.equalToSuperview()
                .inset(Constants.horizontalInsets)
        }
    }
    
    private func passwordConfirmFieldSetup() {
        contentView.addSubview(passwordConfirmField)
               
        passwordConfirmField.isSecureTextEntry = true
        
        passwordConfirmField.snp.makeConstraints { make in
            make.top.equalTo(passwordField.snp.bottom)
                .offset(24)
            make.horizontalEdges.equalToSuperview()
                .inset(Constants.horizontalInsets)
        }
    }
    
    private func capitalLetterLabelSetup() {
        contentView.addSubview(capitalLetterLabel)
        
        capitalLetterLabel.text = "• Заглавная буква"
        capitalLetterLabel.textColor = UIColor(hexString: Constants.textDarkGray)
        
        capitalLetterLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
                .inset(Constants.horizontalInsets)
            make.top.equalTo(passwordConfirmField.snp.bottom)
                .offset(28)
        }
    }
    
    private func numberLabelSetup() {
        contentView.addSubview(numberLabel)
        
        numberLabel.text = "• Цифры"
        numberLabel.textColor = UIColor(hexString: Constants.textDarkGray)
        
        numberLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
                .inset(Constants.horizontalInsets)
            make.top.equalTo(capitalLetterLabel.snp.bottom)
        }
    }
    
    private func specialSymbolLabelSetup() {
        contentView.addSubview(specialSymbolLabel)
        
        specialSymbolLabel.text = "• Специальные символы"
        specialSymbolLabel.textColor = UIColor(hexString: Constants.textDarkGray)
        
        specialSymbolLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
                .inset(Constants.horizontalInsets)
            make.top.equalTo(numberLabel.snp.bottom)
        }
    }
    
    private func passwordsEqualLabelSetup() {
        contentView.addSubview(passwordsEqualLabel)
        
        passwordsEqualLabel.text = "• Совпадение пароля"
        passwordsEqualLabel.textColor = UIColor(hexString: Constants.textDarkGray)
        
        passwordsEqualLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
                .inset(Constants.horizontalInsets)
            make.top.equalTo(specialSymbolLabel.snp.bottom)
        }
    }
    
    private func hidePasswordButtonSetup() {
        passwordField.addSubview(hidePassword)
        
        hidePassword.setImage(UIImage(named: Constants.hidePasswordImage), for: .normal)
        hidePassword.addTarget(self, action: #selector(hidePasswordText), for: .touchUpInside)
        
        hidePassword.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
                .inset(Constants.hidePasswordButtonTrailing)
            make.centerY.equalToSuperview()
        }
    }
    
    private func hidePasswordConfirmButtonSetup() {
        passwordConfirmField.addSubview(hidePasswordConfirm)
        
        hidePasswordConfirm.setImage(UIImage(named: Constants.hidePasswordImage), for: .normal)
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
                .offset(24)
            make.bottom.equalToSuperview()
        }
    }
    
    @objc private func backAction() {
        viewModel.sendEvent(.goToPreviousScreen)
    }
    
    @objc private func hidePasswordText() {
        let isSecure = passwordField.isSecureTextEntry
        passwordField.isSecureTextEntry.toggle()
        hidePassword.setImage(UIImage(named: isSecure ? Constants.hiddenPasswordImage :
                                                Constants.hidePasswordImage), for: .normal)
    }
    
    @objc private func hidePasswordConfirmText() {
        let isSecure = passwordConfirmField.isSecureTextEntry
        passwordConfirmField.isSecureTextEntry.toggle()
        hidePasswordConfirm.setImage(UIImage(named: isSecure ? Constants.hiddenPasswordImage :
                                                Constants.hidePasswordImage), for: .normal)
    }
    
    @objc private func registerUser() {
        print("register")
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
        let customCharacterSet = CharacterSet(charactersIn: "!@#$%ˆ&*˜")
        
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
        passwordsEqualLabel.textColor = (UIColor(hexString: passwordsEqual ? Constants.mainBlueColor : Constants
            .textDarkGray))
        
        if containsUppercasedLetters && containsSymbols && containsDecimalDigits && passwordsEqual && text.count > 6 {
            isSubmitEnabled.send(true)
            print("true")
        } else {
            isSubmitEnabled.send(false)
            print("false")
        }
    }
}
