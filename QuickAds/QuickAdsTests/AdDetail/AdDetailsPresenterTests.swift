//
//  AdDetailsPresenterTests.swift
//  QuickAdsTests
//
//  Created by Mahmoud BEN MESSAOUD on 12/10/2022.
//

import XCTest
@testable import QuickAds

class AdDetailsPresenterTests: XCTestCase {
    var adModel: AdModel!
    let view: MockedAdDetailView? = MockedAdDetailView()
    var interactor: MockedAdDetailInteractor!
    let router: MockedAdDetailRouter = MockedAdDetailRouter()
    var presenter: AdDetailPresenter!
    
    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
        interactor = nil
        presenter = nil
    }
    
    @MainActor func test_handleViewDidLoad_should_CreatesAndBindViewModel_when_always() {
        //arrage
        let date = Date()
        let adModel: AdModel = .init(
            title: "title",
            categoryName: "category",
            date: date,
            description: "descriptiion",
            isUrgent: true,
            imagesUrl: nil,
            price: 1,
            isPro: true
        )
        interactor = MockedAdDetailInteractor(ad: adModel)
        presenter = AdDetailPresenter(view: view, interactor: interactor, router: router)
        
        //acte
        presenter.handle(viewEvent: .viewDidLoad)
        
        //assert
        XCTAssertNotNil(view?.bindedViewModel)
        XCTAssertTrue(view?.bindViewIsCalled == true)
    }
    
    @MainActor func test_handleViewDidLoad_should_CreatesViewModelWithFormattedPrice_when_always() {
        //arrage
        let date = Date()
        let adModel: AdModel = .init(
            title: "title",
            categoryName: "category",
            date: date,
            description: "descriptiion",
            isUrgent: true,
            imagesUrl: nil,
            price: 1,
            isPro: true
        )
        interactor = MockedAdDetailInteractor(ad: adModel)
        presenter = AdDetailPresenter(view: view, interactor: interactor, router: router)
        
        //acte
        presenter.handle(viewEvent: .viewDidLoad)
        let price = view?.bindedViewModel?.price ?? ""
        
        //assert
        XCTAssertTrue(price.contains(" €"))
    }
    
    @MainActor func test_handleViewDidLoad_should_CreatesViewModelWithFormattedDate_when_always() {
        //arrage
        let date = Date()
        let formater = DateFormatter()
        formater.dateFormat = "dd MMMM YYYY à HH:mm"
        let expectedDate = formater.string(from: date)
        
        let adModel: AdModel = .init(
            title: "title",
            categoryName: "category",
            date: date,
            description: "descriptiion",
            isUrgent: true,
            imagesUrl: nil,
            price: 1,
            isPro: true
        )
        interactor = MockedAdDetailInteractor(ad: adModel)
        presenter = AdDetailPresenter(view: view, interactor: interactor, router: router)
        
        //acte
        presenter.handle(viewEvent: .viewDidLoad)
        let resultDate = view?.bindedViewModel?.date ?? ""
        
        //assert
        XCTAssertEqual(resultDate, expectedDate)
    }
    
    

}
