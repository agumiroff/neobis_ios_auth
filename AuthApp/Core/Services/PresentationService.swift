//
//  PresentationService.swift
//  AuthApp
//
//  Created by G G on 05.06.2023.
//

import Foundation
import UIKit

enum PresentationService {
    
    static func present(text: String,
                        from presentingViewController: UIViewController) {
        let view = ModalViewController(labelText: text)
        view.modalPresentationStyle = .overCurrentContext
        presentingViewController.present(view, animated: false, completion: nil)
    }
}