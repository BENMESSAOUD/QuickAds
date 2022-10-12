//
//  MainCoordinator.swift
//  QuickAds
//
//  Created by Mahmoud BEN MESSAOUD on 09/10/2022.
//

import Foundation
import UIKit

final class MainCoordinator {
    
    init() {

    }
    
    func start(in window:  UIWindow?) {
        let networkService = NetworkService()
        let adsListModule = AdsListRouter(
            configuration: .init(initialFilter: nil),
            dependencies: .init(networkService: networkService)
        )
        let adsListView = adsListModule.makeInitial()
        
        let navigationController = UINavigationController(rootViewController: adsListView)
        updateNavigationBarAppearence(navigationController: navigationController)
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
    }
    
    private func updateNavigationBarAppearence(navigationController: UINavigationController) {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemGray6
        appearance.titleTextAttributes = [
            .font: UIFont.boldSystemFont(ofSize: 20.0),
            .foregroundColor: Colors.primaryBlack
        ]

        navigationController.navigationBar.tintColor = Colors.primaryBlack
        navigationController.navigationBar.standardAppearance = appearance
        navigationController.navigationBar.scrollEdgeAppearance = appearance
        navigationController.navigationBar.isTranslucent = false
        navigationController.navigationBar.barStyle = .black
    }
}
