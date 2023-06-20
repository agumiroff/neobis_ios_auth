//
//  PresentationService.swift
//  AuthApp
//
//  Created by G G on 05.06.2023.
//

import Foundation
import UIKit

struct PresentationService {
    
    static func present(text: String,
                        from presentingViewController: UIViewController, action: @escaping () -> Void) {
        let view = ModalViewController(labelText: text, action: action)
        view.modalPresentationStyle = .overCurrentContext
        presentingViewController.present(view, animated: false, completion: nil)
    }
}
