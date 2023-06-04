//
//  ContainerViewController.swift
//  AuthApp
//
//  Created by G G on 04.06.2023.
//

import Foundation
import UIKit
import Combine
import SnapKit

class ContainerView: UIView {
    private let emailView = EmailView()
    var event: AnyPublisher<Event, Never> {
        _event.eraseToAnyPublisher()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        emailViewSetup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func emailViewSetup() {
        addSubview(emailView)
        
        emailView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension ContainerView {
    typealias State = RegistrationViewController.State
    
    enum Event {
        case validateEmail(email: String)
        case checkEmail(email: String)
    }
    
    private var _event: AnyPublisher<Event, Never> {
        emailView.event
            .map { event in
                switch event {
                case let .validateEmail(email):
                    return .validateEmail(email: email)
                case let .checkEmail(email):
                    return .checkEmail(email: email)
                }
            }
            .eraseToAnyPublisher()
    }
    
    func renderUI(_ state: State) {
        switch state {
        case .emailVerifying:
            emailView.isHidden = false
        case .waitForFillingAdditionalInfo:
            emailView.isHidden = true
        case .waitForPasswordEntering:
            emailView.isHidden = true
        case .error:
            emailView.isHidden = false
            emailView.isEmailValid.send(false)
        case .emailCheckSuccess:
            emailView.isEmailValid.send(true)
            emailView.isHidden = false
        }
    }
}
