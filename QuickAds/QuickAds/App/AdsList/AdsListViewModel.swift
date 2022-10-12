import Combine
import Foundation

final class AdsListViewModel: ObservableObject {
    let title: String
    @Published var rows: [AdRow]
    @Published var categories: [CategoriesFilterRow]
    
    init(title: String, rows: [AdRow] = [], categories: [CategoriesFilterRow] = []) {
        self.title = title
        self.rows = rows
        self.categories = categories
    }
}

struct AdRow {
    let title: String
    let image: URL?
    let price: String
    let category: String?
    let date: String
    let isUrgent: Bool
}
