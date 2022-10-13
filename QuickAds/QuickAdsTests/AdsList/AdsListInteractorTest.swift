//
//  AdsListInteractorTest.swift
//  QuickAdsTests
//
//  Created by Mahmoud BEN MESSAOUD on 12/10/2022.
//

import XCTest
import Combine
@testable import QuickAds

class AdsListInteractorTest: XCTestCase {
    var mockedNetworkService: MockedNetworkService!
    var interactor: AdsListInteractor!
    var presenter: MockedAdsListPresenter!
    private var cancellable = Set<AnyCancellable>()
    override func setUpWithError() throws {
        mockedNetworkService = .init()
        presenter = .init()
    }

    override func tearDownWithError() throws {
        mockedNetworkService = nil
        presenter = nil
        interactor = nil
    }
    
    // MARK: - loadAds Test
    
    func test_loadAds_should_callUpdateContent_when_fetchAdsSuccess(){
        //arrage
        interactor = .init(networkService: mockedNetworkService, filter: nil)
        interactor.presenter = presenter
        let result = ClassifiedAd(
            id: 1,
            title: "",
            category_id: 2,
            creation_date: Date(),
            description: "",
            is_urgent: false,
            images_url: nil,
            price: 1, siret: nil
        )
        mockedNetworkService.fetchAdsBehaviour = .success([result])
        let methodCallExpectation = XCTestExpectation()
        
        presenter.$updateContentIsCalled
            .sink { isCalled in
                if isCalled {
                    methodCallExpectation.fulfill()
                }
            }
            .store(in: &cancellable)
        
        //acte
        interactor.loadAds()
        wait(for: [methodCallExpectation], timeout: 1)
        
        //assert
        XCTAssertTrue(presenter.updateContentIsCalled)
    }
    
    func test_loadAds_should_sortResultByUrgentValue_when_fetchAdsSuccess(){
        //arrage
        interactor = .init(networkService: mockedNetworkService, filter: nil)
        interactor.presenter = presenter
        let date = Date()
        let ad1 = ClassifiedAd(
            id: 1,
            title: "",
            category_id: 1,
            creation_date: date,
            description: "",
            is_urgent: false,
            images_url: nil,
            price: 1,
            siret: nil
        )
        let ad2 = ClassifiedAd(
            id: 2,
            title: "",
            category_id: 3,
            creation_date: date,
            description: "",
            is_urgent: false,
            images_url: nil,
            price: 1,
            siret: nil
        )
        let ad3 = ClassifiedAd(
            id: 3,
            title: "",
            category_id: 2,
            creation_date: date,
            description: "",
            is_urgent: true,
            images_url: nil,
            price: 1,
            siret: nil
        )
        mockedNetworkService.fetchAdsBehaviour = .success([ad1, ad2, ad3])
        let methodCallExpectation = XCTestExpectation()
        
        presenter.$updateContentIsCalled
            .sink { isCalled in
                if isCalled {
                    methodCallExpectation.fulfill()
                }
            }
            .store(in: &cancellable)
        
        //acte
        interactor.loadAds()
        wait(for: [methodCallExpectation], timeout: 1)
        //assert
        XCTAssertTrue(presenter.lastAdsListContent == [ad3, ad1, ad2])
    }
    
    func test_loadAds_should_callLoadAdsDidFail_when_fetchAdsFail(){
        //arrage
        interactor = .init(networkService: mockedNetworkService, filter: nil)
        interactor.presenter = presenter
        mockedNetworkService.fetchAdsBehaviour = .fail(.serverError)
        let methodCallExpectation = XCTestExpectation()
        
        presenter.$loadAdsDidFailIsCalled
            .sink { isCalled in
                if isCalled {
                    methodCallExpectation.fulfill()
                }
            }
            .store(in: &cancellable)
        
        //acte
        interactor.loadAds()
        wait(for: [methodCallExpectation], timeout: 1)
        
        //assert
        XCTAssertTrue(presenter.loadAdsDidFailIsCalled)
    }
    
    func test_loadAds_should_callLoadAdsDidFail_when_fetchThrow(){
        //arrage
        interactor = .init(networkService: mockedNetworkService, filter: nil)
        interactor.presenter = presenter
        mockedNetworkService.fetchAdsBehaviour = .throw
        let methodCallExpectation = XCTestExpectation()
        
        presenter.$loadAdsDidFailIsCalled
            .sink { isCalled in
                if isCalled {
                    methodCallExpectation.fulfill()
                }
            }
            .store(in: &cancellable)
        
        //acte
        interactor.loadAds()
        wait(for: [methodCallExpectation], timeout: 1)
        
        //assert
        XCTAssertTrue(presenter.loadAdsDidFailIsCalled)
    }
    
    // MARK: - loadCategories Test
    func test_loadCategories_should_callUpdateContent_when_fetchCategoriesSuccess(){
        //arrage
        interactor = .init(networkService: mockedNetworkService, filter: nil)
        interactor.presenter = presenter
        let result = QuickAds.Category(id: 1, name: "name")
        mockedNetworkService.fetchAdsCategoriesBehaviour = .success([result])
        let methodCallExpectation = XCTestExpectation()
        
        presenter.$updateContentIsCalled
            .sink { isCalled in
                if isCalled {
                    methodCallExpectation.fulfill()
                }
            }
            .store(in: &cancellable)
        
        //acte
        interactor.loadCategories()
        wait(for: [methodCallExpectation], timeout: 1)
        
        //assert
        XCTAssertTrue(presenter.updateContentIsCalled)
    }
    
    func test_loadCategories_should_call$loadCategoriesDidFail_when_fetchFail(){
        //arrage
        interactor = .init(networkService: mockedNetworkService, filter: nil)
        interactor.presenter = presenter
        mockedNetworkService.fetchAdsCategoriesBehaviour = .fail(.serverError)
        let methodCallExpectation = XCTestExpectation()
        
        presenter.$loadCategoriesDidFailIsCalled
            .sink { isCalled in
                if isCalled {
                    methodCallExpectation.fulfill()
                }
            }
            .store(in: &cancellable)
        
        //acte
        interactor.loadCategories()
        wait(for: [methodCallExpectation], timeout: 1)
        
        //assert
        XCTAssertTrue(presenter.loadCategoriesDidFailIsCalled)
    }
    
    func test_loadCategories_should_call$loadCategoriesDidFail_when_fetchThrow(){
        //arrage
        interactor = .init(networkService: mockedNetworkService, filter: nil)
        interactor.presenter = presenter
        mockedNetworkService.fetchAdsCategoriesBehaviour = .throw
        
        let methodCallExpectation = XCTestExpectation()
        presenter.$loadCategoriesDidFailIsCalled
            .sink { isCalled in
                if isCalled {
                    methodCallExpectation.fulfill()
                }
            }
            .store(in: &cancellable)
        
        //acte
        interactor.loadCategories()
        wait(for: [methodCallExpectation], timeout: 1)
        
        //assert
        XCTAssertTrue(presenter.loadCategoriesDidFailIsCalled)
    }

}
