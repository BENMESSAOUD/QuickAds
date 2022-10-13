//
//  MockedNetworkService.swift
//  QuickAdsTests
//
//  Created by Mahmoud BEN MESSAOUD on 12/10/2022.
//

import Foundation
@testable import QuickAds

enum NetworkServiceBehaviours {
    enum FetchAds {
        case fail(NetworkError)
        case success([ClassifiedAd])
        case `throw`
    }
    
    enum FetchAdsCategories {
        case fail(NetworkError)
        case success([QuickAds.Category])
        case `throw`
    }
}

final class MockedNetworkService: NetworkServiceProtocol {
    var fetchAdsBehaviour: NetworkServiceBehaviours.FetchAds = .success([])
    var fetchAdsCategoriesBehaviour: NetworkServiceBehaviours.FetchAdsCategories = .success([])
    func fetchAds() async throws -> Result<[ClassifiedAd], NetworkError> {
        switch fetchAdsBehaviour {
        case .fail(let error):
            return .failure(error)
        case .success(let ads):
            return .success(ads)
        case .throw:
            throw(NSError())
        }
    }
    
    func fetchAdsCategories() async throws -> Result<[QuickAds.Category], NetworkError> {
        switch fetchAdsCategoriesBehaviour {
        case .fail(let error):
            return .failure(error)
        case .success(let categories):
            return .success(categories)
        case .throw:
            throw(NSError())
        }
    }
}
