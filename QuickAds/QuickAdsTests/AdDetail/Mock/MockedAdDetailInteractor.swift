//
//  MockAdDetailInteractor.swift
//  QuickAdsTests
//
//  Created by Mahmoud BEN MESSAOUD on 12/10/2022.
//

@testable import QuickAds
final class MockedAdDetailInteractor: AdDetailInteractorInputProtocol {
    var presenter: AdDetailInteractorOutputProtocol?
    var ad: AdModel
    
    init(ad: AdModel) {
        self.ad = ad
    }
    
    
}
