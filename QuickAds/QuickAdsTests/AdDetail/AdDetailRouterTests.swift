//
//  AdDetailRouterTests.swift
//  QuickAdsTests
//
//  Created by Mahmoud BEN MESSAOUD on 12/10/2022.
//

import XCTest
@testable import QuickAds

class AdDetailRouterTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_makeIntial_should_createModuleWithAllItComponent_when_always(){
        //arrage
        let adModel: AdModel = .init(
            title: "title",
            categoryName: "",
            date: Date(),
            description: "",
            isUrgent: true,
            imagesUrl: nil,
            price: 1,
            isPro: true
        )

        let router = AdDetailRouter(configuration: .init(ad: adModel))
        
        //acte
        let module = router.makeInitial() as? AdDetailView & AdDetailViewProtocol
        let presenter = module?.presenter as? AdDetailPresenterProtocol & AdDetailInteractorOutputProtocol
        
        //assert
        XCTAssertNotNil(module)
        XCTAssertNotNil(presenter)
    }

}
