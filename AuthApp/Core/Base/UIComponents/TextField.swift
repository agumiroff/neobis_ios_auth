//
//  TextField.swift
//  AuthApp
//
//  Created by G G on 25.05.2023.
//

import UIKit
import SnapKit
import Combine

class BaseTextField: UITextField {
    
    // MARK: - Properties
    private var title: String
    private let label = UILabel()
    private var labelConstraint: Constraint?
    private let paddingForText = UIEdgeInsets(top: 32,
                                              left: 10,
                                              bottom: 9,
                                              right: 30)
    private let type: TextFieldType
    var isFilled = CurrentValueSubject<Bool, Never>(false)
    
    // MARK: - Init
    init(title: String, type: TextFieldType) {
        self.title = title
        self.type = type
        
        super.init(frame: CGRect())
        self.delegate = self
        
        setupAppearance()
        subscribe()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - SetupUI
    private func setupAppearance() {
        backgroundColor = UIColor(hexString: Constants.inactiveGray)
        layer.cornerRadius = 8
        placeholder = nil
        
        setupLabel()
    }
    
    // MARK: - Methods
    private func setupLabel() {
        self.addSubview(label)
        
        label.text = title
        label.textColor = UIColor(hexString: "#C1C1C1")
        
        label.snp.makeConstraints { make in
            labelConstraint = make.centerY.equalToSuperview().constraint
            make.leading.trailing.equalToSuperview()
                .inset(10)
        }
    }
}

// MARK: - Delegate
extension BaseTextField: UITextFieldDelegate {
    
    enum TextFieldType {
        case email
        case password
        case date
        case onlyLetters
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch self.type {
        case .email:
            break
        case .password:
            break
        case .date:
            if textField.text?.count ?? 0 > 9 && !string.isEmpty { return false }
            let mask = "##.##.####"
            let text = textField.text?.replacingOccurrences( of: "[^0-9]", with: "", options: .regularExpression)
            textField.text = text?.dateMasking(pattern: mask)
            return true
        case .onlyLetters:
            let allowedCharacters = CharacterSet.letters
            let characterSet = CharacterSet(charactersIn: string)
            return characterSet.isSubset(of: allowedCharacters) || string.isEmpty
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        labelConstraint?.deactivate()
        label.snp.makeConstraints { make in
            labelConstraint = make.top.equalToSuperview().inset(10).constraint
        }
        label.font = UIFont(name: Constants.Font.gothamMedium, size: Constants.Font.small)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == "" {
            labelConstraint?.deactivate()
            label.snp.makeConstraints { make in
                labelConstraint = make.centerY.equalToSuperview().constraint
            }
            label.font = UIFont(name: Constants.Font.gothamMedium, size: Constants.Font.regular)
        }
    }
    
    private func subscribe() {
        addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    @objc private func textDidChange() {
        switch self.type {
        case .email:
            isFilled.send(self.text?.count ?? 0 > 5 && text?.isValidEmail() ?? false)
        case .password:
            isFilled.send(self.text?.count ?? 0 > 5 && text?.isValidPassword() ?? false)
        case .date:
            isFilled.send(self.text?.count ?? 0 == 10)
        case .onlyLetters:
            isFilled.send(self.text?.count ?? 0 > 3)
        }
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: paddingForText)
    }
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: paddingForText)
    }
}
