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
    private let firstNameField = BaseTextField(title: Constants.loginFieldText, type: .onlyLetters)
    private let secondNameField = BaseTextField(title: Constants.loginFieldText, type: .onlyLetters)
    private let dateOfBirthField = BaseTextField(title: Constants.loginFieldText, type: .date)
    private let emailField = BaseTextField(title: "", type: .email)
    private let filledButton = FilledButton(title: "Зарегистрироваться")
    private let viewModel: any AdditionalInfoVM
    private var isSubmitEnabled: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest4(firstNameField.isFilled,
                                  secondNameField.isFilled,
                                  dateOfBirthField.isFilled,
                                  emailField.isFilled)
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
    }
    
    override func setupUI() {
        super.setupUI()
        firstNameFieldSetup()
        secondNameFieldSetup()
        dateOfBirthFieldSetup()
        emailFieldSetup()
        filledButtonSetup()
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
                .inset(40)
        }
    }
    
    private func secondNameFieldSetup() {
        contentView.addSubview(secondNameField)
        
        secondNameField.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
                .inset(Constants.horizontalInsets)
            make.top.equalTo(firstNameField.snp.bottom)
                .offset(24)
        }
    }
    
    private func dateOfBirthFieldSetup() {
        contentView.addSubview(dateOfBirthField)
        
        dateOfBirthField.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
                .inset(Constants.horizontalInsets)
            make.top.equalTo(secondNameField.snp.bottom)
                .offset(24)
        }
    }
    
    private func emailFieldSetup() {
        contentView.addSubview(emailField)
        
        
        emailField.isUserInteractionEnabled = false
        emailField.text = "sdsds@gmail.com"
        emailField.isFilled.send(true)
        emailField.textColor = UIColor(hexString: "#C1C1C1")
        
        let label = UILabel()
        label.text = Constants.loginFieldText
        emailField.addSubview(label)
        label.snp.makeConstraints { make in
            make.leading.top.equalToSuperview()
                .inset(10)
        }
        label.font = UIFont(name: Constants.Font.gothamMedium, size: Constants.Font.small)
        label.textColor = UIColor(hexString: "#C1C1C1")
        
        
        emailField.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
                .inset(Constants.horizontalInsets)
            make.top.equalTo(dateOfBirthField.snp.bottom)
                .offset(24)
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
            make.top.equalTo(emailField.snp.bottom)
                .offset(24)
            make.bottom.equalToSuperview()
        }
    }
    
    @objc private func registerUser() {
        viewModel.sendEvent(.registerUser(firstName: firstNameField.text ?? "",
                                          secondName: secondNameField.text ?? "",
                                          dateOfBirth: dateOfBirthField.text ?? "",
                                          email: emailField.text ?? ""))
    }
}
