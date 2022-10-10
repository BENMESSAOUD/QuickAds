//
//  MockedDecoder.swift
//  QuickAdsTests
//
//  Created by Mahmoud BEN MESSAOUD on 08/10/2022.
//

import Foundation

enum DecoderBehaviour {
    case `throws`(error: Error)
    case decode(object: Decodable)
}

final class MockedDecoder: JSONDecoder {

    var behaviour: DecoderBehaviour = .throws(error: NSError())
    
    override func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        switch behaviour {
        case .throws(let error):
            throw error
        case .decode(let object):
            return object as! T
        }
    }
}
