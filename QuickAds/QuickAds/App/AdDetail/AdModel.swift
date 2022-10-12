//
//  AdModel.swift
//  QuickAds
//
//  Created by Mahmoud BEN MESSAOUD on 12/10/2022.
//

import Foundation
struct AdModel {
    let title: String
    let categoryName: String
    let date: Date
    let description: String
    let isUrgent: Bool
    let imagesUrl: ImageURL?
    let price: Float
    let isPro: Bool
}
