//
//  FilledButton.swift
//  AuthApp
//
//  Created by G G on 25.05.2023.
//

import UIKit

class FilledButton: UIButton {
    
    var hexColor: String
    var cornerRadius: CGFloat
    var title: String
    var textColor: String
    
    init(
        hexColor: String,
        cornerRadius: CGFloat,
        title: String,
        textColor: String
    ) {
        self.hexColor = hexColor
        self.cornerRadius = cornerRadius
        self.title = title
        self.textColor = textColor
        
        super.init(frame: CGRect())
        setupAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupAppearance() {
        backgroundColor = UIColor(hexString: hexColor)
        layer.cornerRadius = cornerRadius
        setTitle(title, for: .normal)
        setTitleColor(UIColor(hexString: textColor), for: .normal)
        titleLabel?.font = UIFont(name: Constants.Font.gothamBold,
                                  size: Constants.Font.regular)
        contentEdgeInsets = UIEdgeInsets(top: 25,
                                         left: 0,
                                         bottom: 25,
                                         right: 0)
    }
}
