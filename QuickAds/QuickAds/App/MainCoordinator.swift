//
//  MainCoordinator.swift
//  QuickAds
//
//  Created by Mahmoud BEN MESSAOUD on 09/10/2022.
//

import Foundation
import UIKit

final class MainCoordinator {
    
    func start(in window:  UIWindow?) {
        let networkService = NetworkService()
        let adsListModule = AdsListRouter(
            configuration: .init(initialFilter: nil),
            dependencies: .init(networkService: networkService)
        )
        let adsListView = adsListModule.makeInitial()
        
        let navigationController = UINavigationController(rootViewController: adsListView)
        navigationController.navigationBar.isTranslucent = false
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
    }
}
