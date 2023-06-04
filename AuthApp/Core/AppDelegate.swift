//
//  AppDelegate.swift
//  authApp
//
//  Created by G G on 24.05.2023.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    // MARK: Properties
    var window: UIWindow?
    var coordinator: AppCoordinator?
    
    // MARK: App lifecycle
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        startApplication()
        
        return true
    }
    
    private func startApplication() {
        let navigation = UINavigationController()
        coordinator = AppCoordinator(navigationController: navigation)
        coordinator?.start()
        window?.rootViewController = navigation
    }
}
