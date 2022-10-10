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
