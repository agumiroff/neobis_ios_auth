//
//  AdditionalInfoVC.swift
//  AuthApp
//
//  Created by G G on 05.06.2023.
//

import Foundation
import UIKit
import SnapKit
import Combine

final class AdditionalInfoVC: BaseViewController {
    
    // MARK: - Properties
    private let firstNameField = BaseTextField(title: Constants.firstNameFieldTitle, type: .onlyLetters)
    private let secondNameField = BaseTextField(title: Constants.lastNameFieldTitle, type: .onlyLetters)
    private let dateOfBirthField = BaseTextField(title: Constants.dateOfBirthFieldTitle, type: .date)
    private let mobilePhoneField = BaseTextField(title: Constants.mobilePhoneFieldTitle, type: .mobilePhone)
    private let filledButton = FilledButton(title: "Зарегистрироваться")
    private let viewModel: any AdditionalInfoVM
    private var isSubmitEnabled: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest4(firstNameField.isFilled,
                                  secondNameField.isFilled,
                                  dateOfBirthField.isFilled,
                                  mobilePhoneField.isFilled)
        .map { return $0 && $1 && $2 && $3 }
        .eraseToAnyPublisher()
    }
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    init(viewModel: any AdditionalInfoVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.sendEvent(.viewDidLoad)
        
        viewModel.state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self else { return }
                switch state {
                case .initial:
                    break
                case let .success(email):
                    self.mobilePhoneField.text = email
                case let .failure(errorMessage):
                    PresentationService.present(text: errorMessage, from: self, action: {
                        self.presentedViewController?.dismiss(animated: false)
                        self.viewModel.sendEvent(.modalClosed)
                    })
                }
            }
            .store(in: &cancellables)
    }
    
    override func setupUI() {
        super.setupUI()
        firstNameFieldSetup()
        secondNameFieldSetup()
        dateOfBirthFieldSetup()
        emailFieldSetup()
        filledButtonSetup()
    }
    
    override func navigationSetup() {
        super.navigationSetup()
        navigationController?.isToolbarHidden = true
        navigationController?.isNavigationBarHidden = true
    }
}

// MARK: - UISetup Methods
extension AdditionalInfoVC {
    
    private func firstNameFieldSetup() {
        contentView.addSubview(firstNameField)
        
        firstNameField.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
                .inset(Constants.horizontalInsets)
            make.top.equalToSuperview()
                .inset(Constants.firstNameFieldTop)
        }
    }
    
    private func secondNameFieldSetup() {
        contentView.addSubview(secondNameField)
        
        secondNameField.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
                .inset(Constants.horizontalInsets)
            make.top.equalTo(firstNameField.snp.bottom)
                .offset(Constants.textFieldTop)
        }
    }
    
    private func dateOfBirthFieldSetup() {
        contentView.addSubview(dateOfBirthField)
        
        dateOfBirthField.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
                .inset(Constants.horizontalInsets)
            make.top.equalTo(secondNameField.snp.bottom)
                .offset(Constants.textFieldTop)
        }
    }
    
    private func emailFieldSetup() {
        contentView.addSubview(mobilePhoneField)
                
        mobilePhoneField.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
                .inset(Constants.horizontalInsets)
            make.top.equalTo(dateOfBirthField.snp.bottom)
                .offset(Constants.textFieldTop)
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
            make.top.equalTo(        mobilePhoneField.snp.bottom)
                .offset(Constants.textFieldTop)
            make.bottom.equalToSuperview()
        }
    }
    
    @objc private func registerUser() {
        viewModel.sendEvent(.registerUser(.init(firstName: firstNameField.text ?? "",
                                                secondName: secondNameField.text ?? "",
                                                dateOfBirth: dateOfBirthField.text ?? "",
                                                email: mobilePhoneField.text ?? "", password: "")))
    }
}

fileprivate extension Constants {
    
    // Strings
    static let firstNameFieldTitle = "Имя"
    static let lastNameFieldTitle = "Фамилия"
    static let dateOfBirthFieldTitle = "Дата рождения"
    static let mobilePhoneFieldTitle = "Номер телефона"
    
    // Constraints
    static let textFieldTop: CGFloat = 24
    static let firstNameFieldTop: CGFloat = 40
}
