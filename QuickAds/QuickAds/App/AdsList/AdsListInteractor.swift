import Darwin

final class AdsListInteractor {
    
    weak var presenter: AdsListInteractorOutputProtocol?
    
    // MARK: Private properties
    private let networkService: NetworkServiceProtocol
    private var adsList: [ClassifiedAd] = []
    private var adsCategories: [Category] = []
    private var filter: AdsFilter
    
    init(networkService: NetworkServiceProtocol, filter: AdsFilter?) {
        self.networkService = networkService
        self.filter = filter ?? .init(categories: [])
    }
    
    // MARK: Private methods
    
    /// Creates error message based on a given `NetworkError` code.
    /// - Parameter error: The error code.
    /// - Returns  A string value containing the error message.
    private func createErrorMessage(_ error: NetworkError) -> String {
        switch error {
        case .wrongURLFormat:
            return "Une erreur technique est survenue. Veuillez contacter le support."
        case .badJSONFormat:
            return "Structure de contenu est inconnue. Veillez réessyer ultérieurement."
        case .badRequest:
            return "Une erreur technqiue est survenue. Veillez réessyer ultérieurement."
        case .requestNotFound:
            return "Ce service est temporairement indisponible. Veillez réessyer ultérieurement."
        case .serverError:
            return "Ce service est temporairement indisponible. Veillez réessyer ultérieurement."
        case .statusCodeNotHandled:
            return "Une erreur technqiue est survenue. Veillez réessyer ultérieurement."
        case .unknown:
            return "Une erreur inconnue est survenue. Veillez réessyer ultérieurement."
        }
    }
    
    /// Filters Ads list by categories
    ///
    /// - Parameter categories: The list of allowed categories
    /// - Returns A filtered Ads list by the given categories array. If the passed categories array is empty, the result will be an array will all fetched Ads.
    private func filterAds(by categories: [Int64]) -> [ClassifiedAd] {
        if categories.isEmpty {
            return adsList
        }
        return adsList.filter({ categories.contains($0.category_id) })
    }
    
    /// Sorts a given Ads list by the urgent status. All urgent ads should be at the top of the list.
    ///
    /// If two ads have the same urgent value, they will be sorted by their creation date.
    /// - Parameter list: The list to sort.
    ///- Returns A sorted Ads list.
    private func sortUrgentAds(list: [ClassifiedAd]) -> [ClassifiedAd] {
        list.sorted(by: {
            if $0.is_urgent == $1.is_urgent {
                return $0.creation_date > $1.creation_date
            }
            return $0.is_urgent == true && $1.is_urgent == false
        })
    }
    
    /// Asynchrony fetch of all Ads.
    private func loadAllAds() {
        Task {
            do {
                let result = try await networkService.fetchAds()
                switch result {
                case let .success(adsList):
                    self.adsList = self.sortUrgentAds(list: adsList)
                    
                    self.applyFilter()
                    
                case let .failure(error):
                    let message = createErrorMessage(error)
                    presenter?.loadAdsDidFail(message: message)
                }
            } catch {
                let message = createErrorMessage(.unknown)
                presenter?.loadAdsDidFail(message: message)
            }
        }
    }
    
    /// Asynchrony fetch of all Categories.
    private func loadAllCategories() {
        Task {
            do {
                let result = try await networkService.fetchAdsCategories()
                switch result {
                case let .success(categories):
                    self.adsCategories = categories
                    self.applyFilter()
                    
                case .failure(_):
                    presenter?.loadCategoriesDidFail()
                }
            } catch {
                presenter?.loadCategoriesDidFail()
            }
        }
    }
    
    /// Applies current filter and ask the presenter to update it content with the new ads and categories list.
    private func applyFilter() {
        let filteredList = filterAds(by: filter.categories)
        presenter?.updateContent(filteredList, categories: adsCategories)
    }
    
    
}
 
// MARK: - AdsList Interactor Input Protocol conformance
extension AdsListInteractor: AdsListInteractorInputProtocol {
    func loadAds() {
        loadAllAds()
    }
    func loadCategories() {
        loadAllCategories()
    }
    
    func getCategoryName(id: Int64) -> String? {
        adsCategories.first(where: { $0.id == id })?.name
    }
    
    func getSelectedCategoriesFilter() -> [Int64] {
        filter.categories
    }
    
    func addCategoryFilter(id: Int64) {
        if filter.categories.contains(id) { return }
        filter.categories.append(id)
        applyFilter()
    }
    
    func removeCategoryFilter(id: Int64) {
        filter.categories.removeAll(where: { $0 == id })
        applyFilter()
    }

}
