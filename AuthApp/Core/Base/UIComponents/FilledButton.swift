//
//  FilledButton.swift
//  AuthApp
//
//  Created by G G on 25.05.2023.
//

import UIKit
import RxSwift
import RxRelay

class FilledButton: UIButton {
    
    var cornerRadius: CGFloat
    var title: String
    private let disposeBag = DisposeBag()
    
    init(
        cornerRadius: CGFloat,
        title: String
    ) {
        self.cornerRadius = cornerRadius
        self.title = title
        
        super.init(frame: CGRect())
        setupAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupAppearance() {
        updateAppearance(isEnabled: isEnabled)
        layer.cornerRadius = cornerRadius
        setTitle(title, for: .normal)
        titleLabel?.font = UIFont(name: Constants.Font.gothamBold,
                                  size: Constants.Font.regular)
        contentEdgeInsets = UIEdgeInsets(top: 25,
                                         left: 0,
                                         bottom: 25,
                                         right: 0)
    }
    
    func updateAppearance(isEnabled: Bool) {
        backgroundColor = UIColor(hexString: isEnabled ? Constants.mainBlueColor : Constants.inactiveGray)
        setTitleColor(UIColor (hexString: isEnabled ? Constants.textWhite : Constants.textDarkGray), for: .normal)
    }
}
