//
//  TextField.swift
//  AuthApp
//
//  Created by G G on 25.05.2023.
//

import UIKit
import SnapKit

class BaseTextField: UITextField, UITextFieldDelegate {
    
    private var hexColor: String
    private var title: String
    private let label = UILabel()
    private var labelConstraint: Constraint?
    private let paddingForText = UIEdgeInsets(top: 32,
                                      left: 10,
                                      bottom: 9,
                                      right: 30)
    
    init(hexColor: String,
         title: String) {
        
        self.hexColor = hexColor
        self.title = title
        
        super.init(frame: CGRect())
        self.delegate = self
        
        setupAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupAppearance() {
        backgroundColor = UIColor(hexString: hexColor)
        layer.cornerRadius = 8
        placeholder = nil
        
        setupLabel()
    }
    
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

extension BaseTextField {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        labelConstraint?.deactivate()
        label.snp.makeConstraints { make in
            labelConstraint = make.top.equalToSuperview().inset(10).constraint
        }
        label.font = UIFont(name: Constants.Font.gothamMedium, size: Constants.Font.small)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if text == "" {
            labelConstraint?.deactivate()
            label.snp.makeConstraints { make in
                labelConstraint = make.centerY.equalToSuperview().constraint
            }
            label.font = UIFont(name: Constants.Font.gothamMedium, size: Constants.Font.regular)
        }
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: paddingForText)
    }
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: paddingForText)
    }
}
