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
    
    init(
        hexColor: String,
        cornerRadius: CGFloat,
        title: String
    ) {
        self.hexColor = hexColor
        self.cornerRadius = cornerRadius
        self.title = title
        
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
        titleLabel?.font = UIFont(name: Constants.Font.gothamBold,
                                  size: Constants.Font.regular)
        contentEdgeInsets = UIEdgeInsets(top: 25,
                                         left: 0,
                                         bottom: 25,
                                         right: 0)
    }
}
