//
//  AppDelegate.swift
//  QuickAds
//
//  Created by Mahmoud BEN MESSAOUD on 08/10/2022.
//

import UIKit

@UIApplicationMain class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let mainCoordinator = MainCoordinator()
        mainCoordinator.start(in: window)
        return true
    }
    
}

