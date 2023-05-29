//
//  AboutView.swift
//  authApp
//
//  Created by G G on 24.05.2023.
//

import Foundation
import UIKit
import SnapKit
import RxSwift

final class WelcomeViewController: BaseViewController {
    
    // MARK: - Properties
    private let viewModel: any WelcomeViewModel
    private let disposeBag = DisposeBag()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    private let smileImage = UIImageView()
    private let welcomeLabel = UILabel()
    private let filledButton = FilledButton(cornerRadius: Constants.filledButtonCornerRadius,
                                            title: Constants.filledButtonTitle)
    private let transparentButton = UIButton()
    
    init(viewModel: any WelcomeViewModel) {
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
        
        filledButton.rx.tap
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: ({[weak self] in
                self?.viewModel.sendEvent(.loginButtonTapped)
            }))
            .disposed(by: disposeBag)
        
        filledButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
                .inset(Constants.horizontalInsets)
            make.top.equalTo(welcomeLabel.snp.bottom)
                .offset(Constants.filledButtonVertical)
        }
    }
    
    private func transparentButtonSetup() {
        contentView.addSubview(transparentButton)
        
        transparentButton.rx.tap
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: ({[weak self] in
                self?.viewModel.sendEvent(.registerButtonTapped)
            }))
            .disposed(by: disposeBag)
        
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

extension WelcomeViewController {
    enum Event {
        case loginButtonTapped
        case registerButtonTapped
    }
}

// MARK: - Constraints and constants
fileprivate extension Constants {
    // Constraints
    static let smileImageVerticalInset = 100.0
    static let smileImageHorizontalInsets = 87.0
    static let welcomeLabelVertical = 60.0
    static let filledButtonVertical = 64.0
    static let filledButtonCornerRadius = 16.0
    static let transparentButtonVertical = 41.0
    // String constants
    static let filledButtonTitle = "Начать пользоваться"
    static let transparentButtonTitle = "Есть аккаунт? Войти"
    static let filledButtonColor = "#FFFFFF"
}
