//
//  AboutView.swift
//  authApp
//
//  Created by G G on 24.05.2023.
//

import Foundation
import UIKit
import SnapKit

final class WelcomeViewController: BaseViewController {
    
    // MARK: - Properties
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let smileImage = UIImageView()
    private let welcomeLabel = UILabel()
    private let filledButton = FilledButton(
        hexColor: Constants.mainBlueColor,
        cornerRadius: Constants.filledButtonCornerRadius,
        title: Constants.filledButtonTitle,
        textColor: Constants.filledButtonColor
    )
    private let transparentButton = UIButton()
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        view.backgroundColor = .white
    }
    
    // MARK: - SetupUI
    override func setupUI() {
        super.setupUI()
        
        scrollViewSetup()
        contentViewSetup()
        smileImageSetup()
        welcomeLabelSetup()
        filledButtonSetup()
        transparentButtonSetup()
    }
}

// MARK: - SetupViews
extension WelcomeViewController {
    
    private func scrollViewSetup() {
        view.addSubview(scrollView)
        
        scrollView.isDirectionalLockEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentSize = .zero
        
        scrollView.snp.makeConstraints { make in
            make.leading.trailing.top.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func contentViewSetup() {
        scrollView.addSubview(contentView)
        
        contentView.snp.makeConstraints { make in
            make.leading.top.trailing.bottom.equalToSuperview()
            make.width.equalTo(scrollView.snp.width)
        }
    }
    
    private func smileImageSetup() {
        contentView.addSubview(smileImage)
        
        smileImage.image = UIImage(named: "Smile")
        
        smileImage.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(Constants.smileImageVerticalInset)
            make.horizontalEdges.equalToSuperview()
                .inset(Constants.smileImageHorizontalInsets)
        }
    }
    
    private func welcomeLabelSetup() {
        contentView.addSubview(welcomeLabel)
        
        welcomeLabel.text = Constants.welcomeLabelText
        welcomeLabel.font = UIFont(name: Constants.Font.gothamBold,
                                   size: Constants.Font.largeTitle)
        welcomeLabel.textColor = UIColor(hexString: Constants.mainBlueColor)
        welcomeLabel.numberOfLines = 3
        
        welcomeLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
                .inset(Constants.horizontalInsets)
            make.top.equalTo(smileImage.snp.bottom)
                .offset(Constants.welcomeLabelVertical)
        }
    }
    
    private func filledButtonSetup() {
        contentView.addSubview(filledButton)
        
        filledButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
                .inset(Constants.horizontalInsets)
            make.top.equalTo(welcomeLabel.snp.bottom)
                .offset(Constants.filledButtonVertical)
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
            make.top.equalTo(filledButton.snp.bottom)
                .offset(Constants.transparentButtonVertical)
            make.bottom.equalToSuperview()
                .inset(Constants.transparentButtonVertical)
        }
    }
}

// MARK: - Constraints and constants
fileprivate extension Constants {
    // Constraints
    static let horizontalInsets = 20.0
    static let smileImageVerticalInset = 100.0
    static let smileImageHorizontalInsets = 87.0
    static let welcomeLabelVertical = 60.0
    static let filledButtonVertical = 64.0
    static let filledButtonCornerRadius = 16.0
    static let transparentButtonVertical = 41.0
    // String constants
    static let welcomeLabelText = "Смейся и улыбайся каждый день"
    static let filledButtonTitle = "Начать пользоваться"
    static let transparentButtonTitle = "Есть аккаунт? Войти"
    static let filledButtonColor = "#FFFFFF"
}
