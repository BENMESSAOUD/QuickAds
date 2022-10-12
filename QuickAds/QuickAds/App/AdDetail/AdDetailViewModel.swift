import Foundation

struct AdDetailViewModel {
    /// Image URL to display. If nil a default image will be displayed.
    let imageURL: URL?
    
    /// Ad title
    let title: String
    
    /// Ad description
    let description: String
    
    /// Ad category name
    let category: String
    
    /// Add price formatted with € currency
    let price: String
    
    /// Ad creation date with `dd MMMM YYYY à HH:mm` format
    let date: String
    
    /// Determines wether the urgent label should be displayed
    let isUrgent: Bool
    
    /// Determines wether the pro label should be displayed
    let isPro: Bool
    
}
