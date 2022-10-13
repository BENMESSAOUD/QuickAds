//
//  MockedURLSession.swift
//  QuickAdsTests
//
//  Created by Mahmoud BEN MESSAOUD on 08/10/2022.
//

import Foundation
@testable import QuickAds

enum URLSessionBehaviour {
    case `throws`(_ error: Error)
    case data(Data, URLResponse)
    case realCall
}

final class MockedURLSession: URLSessionProtocol {
    var cache: URLCacheProtocol?
    
    var behaviour: URLSessionBehaviour = .realCall
    
    func data(from url: URL) async throws -> (Data, URLResponse) {
        switch behaviour {
        case .throws(let error):
            throw error
        case let .data(data, response):
            return (data, response)
        case .realCall:
            return try await URLSession.shared.data(from: url)
        }
    }
}

enum URLCacheBehaviours {
    enum CachedResponseBehaviour {
        case null
        case response(CachedURLResponse)
    }
}

final class MockedURLCache: URLCacheProtocol {
    
    private(set) var storeCachedResponseDidCall = false
    var cachedResponseBehaviour: URLCacheBehaviours.CachedResponseBehaviour = .null
    
    func cachedResponse(for request: URLRequest) -> CachedURLResponse? {
        switch cachedResponseBehaviour {
        case .null:
            return nil
        case .response(let cachedURLResponse):
            return cachedURLResponse
        }
    }
    
    func storeCachedResponse(_ cachedResponse: CachedURLResponse, for request: URLRequest) {
        storeCachedResponseDidCall = true
    }
    
    
}
