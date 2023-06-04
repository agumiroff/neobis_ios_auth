//
//  BaseViewController.swift
//  AuthApp
//
//  Created by G G on 25.05.2023.
//

import Foundation
import UIKit
import Combine

class BaseViewController: UIViewController {
    
    // MARK: - Properties
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    // MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        navigationSetup()
        scrollViewSetup()
        contentViewSetup()
        keyboardNotificationSetup()
    }
    
    func navigationSetup() {
        navigationController?.isToolbarHidden = true
        navigationController?.isNavigationBarHidden = true
    }
}

// MARK: - SetupViews
extension BaseViewController {
    
    func scrollViewSetup() {
        view.addSubview(scrollView)
        
        scrollView.isDirectionalLockEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.contentSize = .zero
        scrollView.bounces = false
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    func contentViewSetup() {
        scrollView.addSubview(contentView)
        
        contentView.snp.makeConstraints { make in
            make.edges.equalTo(scrollView.snp.edges)
            make.width.equalTo(scrollView.snp.width)
        }
    }
    
    private func keyboardNotificationSetup() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(
            self,
            selector: #selector(keyboardDidDissappear),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
        notificationCenter.addObserver(
            self, selector: #selector(keyboarDidAppear),
            name: UIResponder.keyboardWillChangeFrameNotification,
            object: nil
        )
    }
    
    @objc func keyboarDidAppear(notification: Notification) {
        print("didAppear")
        guard let info = notification.userInfo,
              let keyboardFrameValue = info[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue else { return }
        
        let keyboardFrame = keyboardFrameValue.cgRectValue
        let keyboardSize = keyboardFrame.size
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
        let bottomPadding = view.safeAreaInsets.bottom
        let obscuredFrame = CGRect(x: 0,
                                   y: self.view.frame.height - keyboardFrame.height - bottomPadding,
                                   width: self.view.frame.width,
                                   height: keyboardFrame.height + bottomPadding)
        
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        
        if obscuredFrame.intersects(self.contentView.frame) {
            scrollView.scrollRectToVisible(self.contentView.frame, animated: true)
        }
    }
    
    @objc func keyboardDidDissappear(_ notification: NSNotification) {
        print("didDisappear")
        let contentInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
    }
}
