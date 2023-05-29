//
//  AppNavigation.swift
//  AuthApp
//
//  Created by G G on 26.05.2023.
//

import Foundation
import UIKit

final class AppNavigation: UINavigationController, Navigation {
    var coordinator: Coordinator?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        coordinator?.start()
        
        isToolbarHidden = true
        isNavigationBarHidden = true
    }
}
