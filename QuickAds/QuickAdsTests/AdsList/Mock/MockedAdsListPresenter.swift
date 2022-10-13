//
//  MockedAdsListPresenter.swift
//  QuickAdsTests
//
//  Created by Mahmoud BEN MESSAOUD on 12/10/2022.
//

import Foundation
import Combine
@testable import QuickAds

final class MockedAdsListPresenter: ObservableObject, AdsListPresenterProtocol {
    @Published private(set) var updateContentIsCalled = false
    @Published private(set) var loadAdsDidFailIsCalled = false
    @Published private(set) var loadCategoriesDidFailIsCalled = false
    
    private(set) var lastAdsListContent: [ClassifiedAd] = []
    private(set) var lastCategoryList: [QuickAds.Category] = []
    private(set) var lastErrorMessage: String = ""
    
    func handle(viewEvent: AdsListPresenterUnit.Event) {
        
    }
    
    func handle(viewAction: AdsListPresenterUnit.Action) {
        
    }
}

extension MockedAdsListPresenter: AdsListInteractorOutputProtocol {
    func updateContent(_ adsList: [ClassifiedAd], categories: [QuickAds.Category]) {
        lastCategoryList = categories
        lastAdsListContent = adsList
        updateContentIsCalled = true
    }
    
    func loadAdsDidFail(message: String) {
        lastErrorMessage = message
        loadAdsDidFailIsCalled = true
    }
    
    func loadCategoriesDidFail() {
        loadCategoriesDidFailIsCalled = true
    }
    
    
}
