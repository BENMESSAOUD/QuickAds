//
//  Ads.swift
//  QuickAds
//
//  Created by Mahmoud BEN MESSAOUD on 08/10/2022.
//

import Foundation

struct ClassifiedAd: Decodable {
    let id: Int64
    let title: String
    let category_id: Int64
    let creation_date: Date
    let description: String
    let is_urgent: Bool
    let images_url: ImageURL?
    let price: Float
    let siret: String?
}

struct ImageURL: Decodable {
    let small: URL?
    let thumb: URL?
}

// MARK: - ClassifiedAd Equatable conformance.
extension ClassifiedAd: Equatable {
    static func == (lhs: ClassifiedAd, rhs: ClassifiedAd) -> Bool {
        lhs.id == rhs.id
    }
}
