//
//  AdsFilter.swift
//  QuickAds
//
//  Created by Mahmoud BEN MESSAOUD on 08/10/2022.
//

import Foundation

/// This model describes the different filter could be applied on the ads list.
///
/// For the purpose of this test project, only the category filter is required. A filter by pro, featured, price range could be added in this model.
///
struct AdsFilter {
    /// Filter by a set of categories ids.
    var categories: [Int64]
}
