//
//  Navigation.swift
//  AuthApp
//
//  Created by G G on 25.05.2023.
//

import UIKit

class AppNavigation: UINavigationController {
    var coordinator: AppCoordinator?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        coordinator?.start()
    }
}
