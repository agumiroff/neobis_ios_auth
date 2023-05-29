//
//  ViewController.swift
//  authApp
//
//  Created by G G on 24.05.2023.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class LoginViewController: BaseViewController {
    
    // MARK: - Properties
    private let disposeBag = DisposeBag()
    private let viewModel: any LoginViewModel
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let smileImage = UIImageView()
    private let hidePasswordButton = UIButton()
    private let loginField = BaseTextField(hexColor: Constants.inactiveGray,
                                           title: Constants.loginFieldText)
    private let passwordField = BaseTextField(hexColor: Constants.inactiveGray,
                                              title: Constants.passwordFieldTitle)
    private let validatingLabel = UILabel()
    private let filledButton = FilledButton(cornerRadius: Constants.filledButtonCornerRadius,
                                            title: Constants.filledButtonTitle)
    private let transparentButton = UIButton()
    private let spacer = UIView()
    private let isLoginValid = BehaviorRelay<Bool>(value: false)
    private let isPasswordValid = BehaviorRelay<Bool>(value: false)
    private var isAuthEnabled: Observable<Bool> {
        return Observable.combineLatest(isLoginValid, isPasswordValid) { return $0 && $1 }
    }
    
    init(viewModel: any LoginViewModel) {
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
    }
    
    // MARK: - SetupUI
    override func setupUI() {
        super.setupUI()
        notificationCenterSetup()
        
        scrollViewSetup()
        contentViewSetup()
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
extension LoginViewController {
    
    private func scrollViewSetup() {
        view.addSubview(scrollView)
        
        scrollView.isDirectionalLockEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentSize = .zero
        scrollView.bounces = false
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func contentViewSetup() {
        scrollView.addSubview(contentView)
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.snp.edges)
            make.width.equalTo(scrollView.snp.width)
        }
    }
    
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
        
        loginField.rx.text
            .filter { text in
                guard let text = text else { return false }
                let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
                return !trimmedText.isEmpty
            }
            .subscribe(onNext: { [weak self] text in
                guard let text = text else { return }
                if text.isValidEmail() {
                    self?.validatingLabel.text = ""
                    self?.validatingLabel.isHidden = true
                    self?.isLoginValid.accept(true)
                } else {
                    self?.validatingLabel.text = Constants.emailCheckFailed
                    self?.validatingLabel.isHidden = false
                    self?.isLoginValid.accept(false)
                }
            })
            .disposed(by: disposeBag)
        
        loginField.snp.makeConstraints { make in
            make.top.equalTo(smileImage.snp.bottom)
                .offset(Constants.loginFieldTop)
            make.horizontalEdges.equalToSuperview()
                .inset(Constants.horizontalInsets)
        }
    }
    
    private func passwordFieldSetup() {
        contentView.addSubview(passwordField)
        
        passwordField.rx.text
            .filter { text in
                guard let text = text else { return false }
                let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
                return !trimmedText.isEmpty
            }
            .subscribe(onNext: { [weak self] text in
                guard let text = text else { return }
                if text.isValidPassword() {
                    self?.validatingLabel.text = ""
                    self?.validatingLabel.isHidden = true
                    self?.isPasswordValid.accept(true)
                } else {
                    self?.validatingLabel.text = Constants.passCheckFailed
                    self?.validatingLabel.isHidden = false
                    self?.isPasswordValid.accept(false)
                }
            })
            .disposed(by: disposeBag)
        
        passwordField.isSecureTextEntry = true
        
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
        
        isAuthEnabled
            .subscribe { [weak self] in
                self?.filledButton.isEnabled = $0
                self?.filledButton.updateAppearance(isEnabled: $0)
            }
            .disposed(by: disposeBag)
        
        filledButton.rx.tap
            .subscribe(onNext: { _ in
                print("dsdsds")
            })
            .disposed(by: disposeBag)
        
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
        transparentButton.titleLabel?.font = UIFont(name: Constants.Font.gothamBold,
                                                    size: Constants.Font.regular)
        transparentButton.setTitleColor(.black, for: .normal)
        
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
extension LoginViewController {
    
    private func notificationCenterSetup() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(
            self,
            selector: #selector(keyboardDidDissappear),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        notificationCenter.addObserver(
            self, selector: #selector(keyboarDidAppear),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
    }
    
    @objc func hidePassword() {
        let isSecure = passwordField.isSecureTextEntry
        passwordField.isSecureTextEntry.toggle()
        hidePasswordButton.setImage(UIImage(named: isSecure ? Constants.hiddenPasswordImage :
                                                Constants.hidePasswordImage), for: .normal)
    }
    
    @objc func keyboarDidAppear(notification: Notification) {
        guard let info = notification.userInfo,
              let keyboardFrameValue = info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue else { return }
        
        let keyboardFrame = keyboardFrameValue.cgRectValue
        let keyboardSize = keyboardFrame.size
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
        let bottomPadding = view.safeAreaInsets.bottom
        let obscuredFrame = CGRect(x: 0,
                                   y: self.view.frame.height - keyboardFrame.height - bottomPadding,
                                   width: self.view.frame.width,
                                   height: keyboardFrame.height + bottomPadding)
        
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        
        if obscuredFrame.intersects(self.filledButton.frame) {
            scrollView.scrollRectToVisible(self.filledButton.frame, animated: true)
        }
    }
    
    @objc func keyboardDidDissappear(_ notification: NSNotification) {
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
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
    static let filledButtonTop = 60.0
    
    static let validatingLabelTop = 16.0
    
    static var transparentButtonTop = 198.0
    static let transparentButtonBottom = 16.0
    
    static let hidePasswordButtonTrailing = 12.0
    static let hidePasswordButtonTop = 30.0
    static let hidePasswordButtonBottom = 14.0
    
    // Strings
    static let transparentButtonTitle = "Забыли пароль?"
    static let loginFieldText = "Электронная почта"
    static let passwordFieldTitle = "Пароль"
    static let filledButtonTitle = "Войти"
    static let emailCheckFailed = "e-mail заполнен неверно"
    static let passCheckFailed = String("Пароль должен содержать только английские буквы и цифры и меть длину не менее 8 символов.")
    // Names
    static let hidePasswordImage = "passHide"
    static let hiddenPasswordImage = "passHidden"
}
