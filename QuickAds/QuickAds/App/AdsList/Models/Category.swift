//
//  AdsCategory.swift
//  QuickAds
//
//  Created by Mahmoud BEN MESSAOUD on 08/10/2022.
//

struct Category: Decodable {
    let id: Int64
    let name: String
}

// MARK: - Category Equatable conformance.
extension Category: Equatable {
    static func == (lhs: Category, rhs: Category) -> Bool {
        lhs.id == rhs.id
    }
}



