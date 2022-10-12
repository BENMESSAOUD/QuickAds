//
//  MockedAdDetailView.swift
//  QuickAdsTests
//
//  Created by Mahmoud BEN MESSAOUD on 12/10/2022.
//

@testable import QuickAds

final class MockedAdDetailView: AdDetailViewProtocol {
    var presenter: AdDetailPresenterProtocol?
    
    private(set) var bindViewIsCalled = false
    private(set) var bindedViewModel: AdDetailViewModel?
    func bind(viewModel: AdDetailViewModel) {
        self.bindedViewModel = viewModel
        bindViewIsCalled = true
    }
}
